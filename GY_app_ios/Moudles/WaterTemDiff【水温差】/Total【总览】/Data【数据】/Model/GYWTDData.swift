//
//  GYWTDData.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/17.
//

import UIKit
import HandyJSON

class GYWTDData: HandyJSON {
    required init() { }
}

struct GYWTDDataData:HandyJSON {
    var reFlowTagValue:Int64? = 0
    var inTagValue:Int64? = 0
    var flowTagValue:Int64? = 0
    var outTagValue:Int64? = 0
    var angle:Int64? = 0
    var stove_id:Int64? = 0
    var wcValue:Int64? = 0
    var stove_number:String? = ""
}
