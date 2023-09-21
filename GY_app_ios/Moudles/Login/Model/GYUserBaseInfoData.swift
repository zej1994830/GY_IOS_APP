//
//  GYUserBaseInfoData.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import UIKit

class GYUserBaseInfoData: GYUserLoginData {
    static var `default`:  GYUserBaseInfoData {
        if let userInfo = CommonCache.getCacheData(CacheKey.userDataInfoCacheKey) as? GYUserBaseInfoData{
            return userInfo
        }
        
        return GYUserBaseInfoData()
    }
    
    //公司
    var subordinate_unit: String = ""
    
    var user_type: Int64 = 0
    //莫名其妙
    var user_id2: String = ""
    //登录时间
    var landing_time: NSArray = []
    
    var user_name: String = ""
    
    var user_account: String = ""
    //设备，数组里是字典
    var device_list:NSArray = []
    //设备，数组里是字典
    var device_listname:NSMutableArray = []
    
    convenience init(signData: NSDictionary){
        self.init()
        self.isLogin = true
        self.user_id = signData["user_id"] as! Int64
//        self.token = signData.token
        
//        SDWebImageDownloader.shared.setValue(signData.token, forHTTPHeaderField: "token ")
    }
    
    class func getUserInfo(data:NSDictionary) -> GYUserBaseInfoData{
        let cachedUserInfo = GYUserBaseInfoData.default
        cachedUserInfo.subordinate_unit = data["subordinate_unit"] as! String
        cachedUserInfo.user_type = data["user_type"] as! Int64
//        cachedUserInfo.user_id2 = data["user_id"] as! String
        cachedUserInfo.landing_time = data["landing_time"] as! NSArray
        cachedUserInfo.user_name = data["user_name"] as! String
        cachedUserInfo.user_account = data["user_account"] as! String
        cachedUserInfo.device_list = data["device_list"] as! NSArray
        cachedUserInfo.device_listname.removeAllObjects()
        
        for dic in cachedUserInfo.device_list {
            let dicc = dic as! NSDictionary
            cachedUserInfo.device_listname.add(("",dicc["device_name"]))
        }
        
        let deviceDataInfo = GYDeviceData.getDeviceDataInfo(data: cachedUserInfo.device_list.firstObject as! NSDictionary)
        CommonCache.cacheData(deviceDataInfo, key: CacheKey.GYDeviceDataCacheKey)
        
        
        return cachedUserInfo
        
    }
    
    override init() {
        super.init()
    }
    
    
    //手动解归档
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isLogin = coder.decodeBool(forKey: "isLogin")
        self.user_id = coder.decodeInt64(forKey: "user_id")
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.isLogin, forKey: "isLogin")
        coder.encode(self.user_id, forKey: "user_id")
    }
}

class GYDeviceData:GYCodingObject {
    //        [0]    (null)    "device_type" : Int64(1)
    //        [1]    (null)    "id" : Int64(2032)
    //        [2]    (null)    "end_time" : "2030-05-29"
    //        [3]    (null)    "start_time" : "2019-05-29"
    //        [4]    (null)    "device_db" : "U2VydmVyPShsb2NhbCk7RGF0YWJhc2U9Z2xjd190c3hidF80IztVc2VyIElEPXNhO1Bhc3N3b3JkPWFzVDIwMjAyMTM1ZTs="
    //        [5]    (null)    "device_name" : "唐山新宝泰4#高炉"
    var device_type: Int64 = 0
    var id: Int64 = 0
    var end_time: String = ""
    var start_time: String = ""
    var device_db: String = ""
    var device_name: String = ""
    
    static var `default`:  GYDeviceData {
        if let userInfo = CommonCache.getCacheData(CacheKey.GYDeviceDataCacheKey) as? GYDeviceData{
            return userInfo
        }
        
        return GYDeviceData()
    }
    
    class func getDeviceDataInfo(data:NSDictionary) -> GYDeviceData{
        let cachedUserInfo = GYDeviceData.default
        cachedUserInfo.device_type = data["device_type"] as! Int64
        cachedUserInfo.id = data["id"] as! Int64
        cachedUserInfo.end_time = data["end_time"] as? String ?? ""
        cachedUserInfo.start_time = data["start_time"] as? String ?? ""
        cachedUserInfo.device_db = data["device_db"] as! String
        cachedUserInfo.device_name = data["device_name"] as! String

        return cachedUserInfo
        
    }
}
