//
//  GYWTDTrendData.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/25.
//

import UIKit
import HandyJSON

class GYWTDTrendData: HandyJSON {
    required init() { }
}

struct GYWTTrendBaseModel:HandyJSON {
    /**时间*/
    var dt:String = ""
    /**流量*/
    var flow:NSNumber = 0
    /**入水温度*/
    var inTemp:NSNumber = 0
    /**出水温度*/
    var outTemp:NSNumber = 0
    /**热流*/
    var reFlow:NSNumber = 0
    /**温差*/
    var tempWc:Int = 0
}
