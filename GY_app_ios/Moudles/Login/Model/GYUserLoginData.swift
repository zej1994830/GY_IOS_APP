//
//  GYUserLoginData.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import UIKit
import PINCache

class GYUserLoginData: GYCodingObject {
    
    // 是否登录,只有在
    var isLogin: Bool = false
    // 用户ID
    var user_id: Int64 = 0
    // 用户token
    var token: String = ""
}
