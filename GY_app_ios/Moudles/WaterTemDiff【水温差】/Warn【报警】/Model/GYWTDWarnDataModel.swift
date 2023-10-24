//
//  GYWTDWarnDataModel.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/19.
//

import UIKit
import HandyJSON

class GYWTDWarnData: HandyJSON {
    required init() { }
}

struct GYWTDWarnDataModel:HandyJSON {
    var date:String? = ""
    var detail:String? = ""
    var tag_Id:Int? = 0
    var alarm_type:Int? = 0
    var id_type:Int? = 0
    var state:Int? = 0
    
}
