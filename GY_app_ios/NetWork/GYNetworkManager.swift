//
//  GYNetworkManager.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/11.
//

import UIKit
import Alamofire
/**
 * 网络请求管理类,这个类负责与Alamofire的对接,基本设置,提供一些基础的方法
 *
 * 功能:
 *  1.灵活转换网络服务器地址,这个类应该提供接口,方便网络服务器的地址转换 √
 *  2.提供基础的api方法
 *      2.1 下载文件
 *      2.2 上传文件
 *      2.3 请求api数据
 *  3.灵活的token配置,网络请求需要带token,或者不带token,应该有比较灵活的方法处理token
 *
 *
 *
 */

protocol GYNetworkSplicer {
    
    func splicingRealyAPI(api: String) ->  String;
}

/// 网络请求Logger实现此协议,解耦日志层
protocol GYNetworkLogger {
    
    func logRequestAndResponse(request: URLRequest?,response: HTTPURLResponse?, serializationDuration: TimeInterval);
}

extension GYNetworkLogger {
    
    func logRequestAndResponse(request: URLRequest?,response: HTTPURLResponse?, serializationDuration: TimeInterval){
        
        let requestStr = "request url:\t\t\(request?.url?.absoluteString ?? "无请求url")\nrequest header:\t\t\( request?.allHTTPHeaderFields ?? [:])\nrequest body:\t\t\(request?.httpBody ?? Data())\n"
        
        let responseStr = "response statusCode:\t\t\(response?.statusCode ?? 0)\nresponse header:\t\(response?.allHeaderFields ?? [:])\nresponse time:\t\t\(serializationDuration)"
    }
}

/// 网络数据缓存类型
enum GYNetworkCacheType {
    case none       // 不缓存
    case normal     // 正常缓存
    case secret     // 加密缓存,暂时不实现
}

enum GYNetworkStatusType {

    case unowned
    case notReachable
    case reachable(ConnectionType)
}

enum ConnectionType {
    
    case ethernetOrWiFi
    
    case cellular
}

class GYNetworkManager {
    
    
    /// 网络管理类,单例设计
    static let share = GYNetworkManager()
    
    /// 默认的网络Session
    private(set) var GYSession: Session = AF
    
    private(set) var curtentRequest: Request? = nil
    
    private(set) var networkStatus: GYNetworkStatusType = .unowned
    
    /// 网络监听器
    private let reachabilityManger = NetworkReachabilityManager(host: "www.baidu.com")
    
    open var logger: GYNetworkLogger? = GYDefaultNetworkLogger()
    
    init() {
        defaultSetting()
    }
    
    
    func startListeningNetWorking(){
    
        reachabilityManger?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { [weak self] (status) in
            
            guard let weakSelf = self else{
                return
            }
            switch status {
            case .unknown: // 未知网络
                weakSelf.networkStatus = .unowned
                break
            case .notReachable: // 网络不可用
                weakSelf.networkStatus = .notReachable
                break
            case .reachable(.cellular): // 蜂窝网络
                weakSelf.networkStatus = .reachable(.cellular)
                break
            case .reachable(.ethernetOrWiFi): // wifi网络
                weakSelf.networkStatus = .reachable(.ethernetOrWiFi)
                break
            }
            
            NotificationCenter.default.post(name: NotificationConstant.networkStatusChanged, object: nil, userInfo: [NotificationParam.networkStatusParam: status])
            
        })
    }
    
    // 网络参数的一些默认设置
    private func defaultSetting(){

        let policy = RetryPolicy.init(retryLimit: 3)
        
        let session = Session.init(configuration: URLSessionConfiguration.af.default,  interceptor: policy)
        GYSession = session
    }
    
    private func commRequestErrorHud(_ testingText: String, releaseText: String = "网络错误,请检查网络连接..."){
        #if TESTING
        GYHUD.showError(testingText)
        #else
        GYHUD.showError(releaseText)
        #endif
    }
    
    func requestAPIData(_ api: String, cacheKey: String = "", cacheType: GYNetworkCacheType = .none, method: HTTPMethod = .post, apiSplicer: GYNetworkSplicer? = nil, interceptor: RequestInterceptor? = nil, encoder: ParameterEncoder, validation: @escaping DataRequest.Validation, bodyParamas: Data? = nil, completeData: @escaping ((Data?)->Void), errorBlock: @escaping ((AFError)->Void)) -> Request?{
        
        var apiString: String = api
        // 1.api拼接器,可以由外界提供单独的拼接器
        if apiSplicer != nil {
            apiString = apiSplicer!.splicingRealyAPI(api: api)
        }
        
        // tips 请求头什么的,可以通过APIManager的拦截器设置
        let dataRequest = GYSession.request(apiString, method: method, parameters: bodyParamas, encoder: encoder, interceptor: interceptor).validate(validation)
        
        dataRequest.response { [weak self] (response) in
            
            guard let weakSelf = self else{
                return
            }
            
            weakSelf.logger?.logRequestAndResponse(request: response.request, response: response.response, serializationDuration: response.serializationDuration)
            
            switch response.result{
            case .success(let data):
                completeData(data)
                
            case .failure(let error):
                errorBlock(error)
            }
            
        }
        return dataRequest
    }
    
    
    /// 发送请求的主要方法,负责发送最终的网络请求
    /// - Parameters:
    ///   - api: 请求的api eg: "/userInfo"
    ///   - cacheKey: 缓存的路径
    ///   - cacheType: 缓存的类型,默认不缓存
    ///   - method: 请求的方式
    ///   - bodyParamas: 请求的protobuf序列化的参数
    ///   - completeData: 处理数据的block
    /// - Returns: 返回请求的Request,用于取消或者加入队列等
    func getApiData(_ api: String, cacheKey: String = "", cacheType: GYNetworkCacheType = .normal, method: HTTPMethod = .post,bodyParamas: Data? = nil, completeData: @escaping ((Data?)->Void)) -> Request?{
        
        guard let request = handleRequest(api, method: method, bodyParamas: bodyParamas) else {
            
            commRequestErrorHud("处理拼接网络请求出错")
            completeData(nil)
            return nil
        }
        
        let dataRequest = GYSession.request(request)
        dataRequest.response { [weak self] (result) in
            
            let requestStr = "request url:\t\t\(request.url?.absoluteString ?? "无请求url")\nrequest header:\t\t\( request.allHTTPHeaderFields ?? [:])\nrequest body:\t\t\(request.httpBody ?? Data())\n"
            
            let responseStr = "response statusCode:\t\t\(result.response?.statusCode ?? 0)\nresponse header:\t\(result.response?.allHeaderFields ?? [:])\nresponse data:\t\t\(result.result)"
            
            guard let weakSelf = self else{
                return
            }
            
            /// 处理403授权失败
//            weakSelf.handleResponseError(result: result)
            
            
            switch result.result{
            case .success(let data):
                weakSelf.handleCommonError(response: result.response, error: nil)
                completeData(data)
                
            case .failure(let error):
                
                weakSelf.handleCommonError(response: nil, error: error)
                weakSelf.commRequestErrorHud(error.errorDescription ?? "网络响应出错")
                completeData(nil)
            }
            
        }
        
        return dataRequest
    }
    
    private func handleResponseError(result: AFDataResponse<Any>){
        /// 处理403授权失败, 只有当状态为登录,且授权失败才会响应登录界面,如果本身状态未登录,就不需要反复提醒
        if result.response?.statusCode != 200 && result.response?.statusCode != nil {
            GYHUD.hideHudForView()
            GYHUD.show(String(format: "statusCode = %d", result.response!.statusCode))
            return
        }
        
    }
    
    private func handleDownloadResponseError(result: AFDownloadResponse<Data>){
        /// 处理403授权失败, 只有当状态为登录,且授权失败才会响应登录界面,如果本身状态未登录,就不需要反复提醒
        
    }
    
    @discardableResult func uploadImageData(data: Data, needToken: Bool = true, uploadProgress: ((Progress) -> Void)? = nil,completeData: @escaping ((Data?)->Void)) -> Request?{
        return nil
    }
    
    
    /// 下载文件方法,没有校验下载头
    /// - Parameters:
    ///   - urlString: 文件url全路径
    ///   - destinationName: 下载后的名字
    ///   - directory: 存放位置
    ///   - completeData: 返回响应值,文件的全路径,错误信息
    /// - Returns: 下载请求
    @discardableResult func downloadFile(urlString: String, isAbsolutePath: Bool = false, destinationName: String, directory: FileManager.SearchPathDirectory = .cachesDirectory, completeData: @escaping ((Data?,URL?,Error?)->Void)) -> DownloadRequest?{
        return nil
    }
    
    func downloadModelFile(filePath: String, completeData: @escaping ((Data?)->Void)) -> DownloadRequest?{
        return nil
    }
    
    /// 缓存数据
    /// - Parameters:
    ///   - cacheType: 缓存类型,一般为不缓存,正常缓存,加密缓存
    ///   - cachekey: 缓存路径
    ///   - data: 缓存的Data,这个Data应该是实现了NSCoding编码后的Data
    private func cacheData(cacheType: GYNetworkCacheType = .normal, cachekey: String = "", data: Data){
        
        switch cacheType {
        case .none:
            break
        case .normal:
            CommonCache.share.apiDataCache.setObject(data as NSCoding, forKey: cachekey)
        case .secret:
            CommonCache.share.apiDataCache.setObject(data as NSCoding, forKey: cachekey)
        }
    }
    
    /// 获取protobuf缓存内容
    /// - Parameters:
    ///   - cacheType: 缓存类型
    ///   - cachekey: 缓存路径
    /// - Returns: 返回查找到的数据
    func getCacheData(cacheType: GYNetworkCacheType = .normal, cachekey: String = "") -> Data? {
        
        guard let data = CommonCache.share.apiDataCache.object(forKey: cachekey) as? Data else{
            return nil
        }
        return data
    }
    
    /// 处理请求类,设置请求的参数和请求的类型,特殊请求头等相关设置
    /// - Parameters:
    ///   - api: 请求的api eg: "/userInfo"
    ///   - method: 请求方式,默认.post
    ///   - bodyParamas: 请求的protobuf参数,这个参数写在httpbody里面
    /// - Returns: 返回request,可能为nil,错误处理就在这一层处理
    private func handleRequest(_ api: String, method: HTTPMethod = .post,bodyParamas: Data? = nil) -> URLRequest?{
        
        let urlString = APP.API_SERVER + api
        do {
            var request = try URLRequest.init(url: urlString, method: .post)
            request.httpBody = bodyParamas
            request.httpMethod = method.rawValue
//            if !TFUserBaseInfoData.default.token.isEmpty{
//                request.headers["token"] = TFUserBaseInfoData.default.token
//            }
            //暂定
            request.headers["token"] = "0123456789ABCDEF"
            return request
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func requestData(_ type : HTTPMethod, api : String, parameters : [String : Any],token:String? = "", finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        
        let urlString = APP.API_SERVER + api
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        let header:HTTPHeaders = [
            HTTPHeader(name: "api_token", value: token?.count != 0 ? token! : "0123456789ABCDEF")
        ]
        Alamofire.AF.request(urlString, method: method, parameters: parameters,headers: header).responseJSON {[weak self] (response) in
            guard let weakSelf = self else{
                return
            }
            //处理失败
            if response.response?.statusCode != 200 && response.response?.statusCode != nil {
                GYHUD.hideHudForView()
                GYHUD.show(String(format: "statusCode = %d", response.response!.statusCode))
                return
            }
            switch response.result {
            case .success(let json):
                finishedCallback(json)
                break
            case .failure(let error):
                print("error:\(error)")
                break
            }
        }
    }
}
//MARK: - 错误处理
extension GYNetworkManager {
    
    private func handleCommonError(response: HTTPURLResponse? = nil, error: AFError? = nil){
        
        if error != nil {
            
        }
    }
}
