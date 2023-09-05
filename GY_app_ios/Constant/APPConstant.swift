//
//  APPConstant.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/9.
//

import UIKit
/**
    app相关的一些常量,例如当前环境,iOS版本,ipad版本,基础设备信息等
 */
struct APP{
    #if TESTING
//    static let API_SERVER: String = "http://192.168.100.69:54321/api/"
    static let API_SERVER: String = "http://36.129.131.242:8181/api/"
    static let API_IMGAE_SERVER: String = "http://36.129.131.242:6060"
    #else
    static let API_SERVER: String = "http://36.129.131.242:8181/api/"
    static let API_IMGAE_SERVER: String = "http://36.129.131.242:6060"
    #endif
    
    static let IOS_VERSION: Float = Float(UIDevice.current.systemVersion) ?? -1
    static let WIDTH: CGFloat = UIScreen.main.bounds.width
    static let HEIGHT: CGFloat = UIScreen.main.bounds.height
    static let IS_IPHONE: Bool = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let IS_IPAD: Bool = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
}
class APPConstant: NSObject {

}
