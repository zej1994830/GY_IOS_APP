//
//  GYTotalBarChartModel.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/10.
//

import UIKit
import HandyJSON

class GYTotalBarChartModel: HandyJSON {
    required init() { }
}

struct GYTotalBarCharDatatModel:HandyJSON {
    var partId:Int64? = 0
    var Id:Int64? = 0
    var isException:Int64? = 0
    var masterAddress:Int64? = 0
    var tempTagValue:Double? = 0
    var partName:String? = ""
    var temperatureValue:Any = ""
    var name:String? = ""
    var slaveAddress:Int64? = 0
}
