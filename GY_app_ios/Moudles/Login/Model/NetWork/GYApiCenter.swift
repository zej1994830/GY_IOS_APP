//
//  GYApiCenter.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/28.
//

import UIKit

struct Api {
    //登录
    static let getlogin: String = "oauth/auth"
    //版本更新
    static let getversion: String = "Oauth/Version"
    //用户信息
    static let getuserinfo: String = "account/profile"
    //版本更新
    static let getupdataversion: String = "Oauth/Version"
    //修改密码
    static let posteditpassword: String = "Account/Editpassword"
    //轮播图
    static let getbanner: String = "account/GetRotationChart"
    //设备有效期
    static let getdevicetime: String = "account/checkdateinvalid"
}
