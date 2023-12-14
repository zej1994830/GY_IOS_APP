//
//  GYWTDRadarModel.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/24.
//

import UIKit
import HandyJSON

class GYWTDRadarData: HandyJSON {
    var reFlowTagValue:Double? = 0
    var inTagValue:Double? = 0
    var flowTagValue:Double? = 0
    var outTagValue:Double? = 0
    var angle:Int64? = 0
    var stove_id:Int64? = 0
    var wcValue:Double? = 0
    var stove_number:String? = ""
    var stove_name:String? = "" //热电偶用到的名字
    required init() { }
}

struct GYWTDRadarModel:HandyJSON {
    var offsetAngle2:Int64? = 0
    var clockwise:Int64? = 0
    var offsetAngle:Int64? = 0
    var section_id:Int64? = 0
    var section_name:String? = ""
    var stove_list:NSArray = []
}

struct GYRTRadarModel:HandyJSON {
    var r_max:Int64? = 0
    var resultModel:NSArray = []
    var offsetAngle2:Int64? = 0
    var clockwise:Int64? = 0
    var offsetAngle:Int64? = 0
}

struct GYRTRadarData:HandyJSON {
    var id:String? = ""
    var elevation:String? = ""
    var insertion_angle:String? = ""
    var temperature:String? = ""
    var alarm:String? = ""
    var insertion_height:String? = ""
    var h_T:String? = ""
    var hh_T:String? = ""
    var l_T:String? = ""
    var ll_T:String? = ""
    var name:String? = ""
}

