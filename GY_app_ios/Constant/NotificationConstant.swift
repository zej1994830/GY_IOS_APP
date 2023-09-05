//
//  NotificationConstant.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/17.
//

import UIKit

struct NotificationConstant{
    //登录成功通知主页刷新
    static let locationSuccess = NSNotification.Name(rawValue: "locationSuccess")
}
//MARK: - 网络相关

extension NotificationConstant {
    
    /// 网络状态值改变
    static let networkStatusChanged = NSNotification.Name(rawValue: "networkStatusChanged")
}

/// 通知参数
struct NotificationParam {
    /// 网络状态参数
    static let networkStatusParam = "networkStatusParam"
    
}
