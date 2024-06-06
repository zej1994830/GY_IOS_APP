//
//  GYFSModel.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/6.
//

import UIKit
import HandyJSON

class GYFSModel: HandyJSON {
    required init() { }
}

struct GYFSDataModel:HandyJSON {
    /**当前分段中标签编号*/
    var name:String? = ""
    /**当前分段中标签id*/
    var id:Int64? = 0
    /***/
    var partId:Int64? = 0
    /**当前分段中标签地址*/
    var masterAddress:Int64? = 0
    /**温度异常 */
    var isException:Int64? = 0
    /**温度 */
    var tempTagValue:Double? = 0
    /***/
    var partName:String? = ""
    /** */
    var section_name:String? = ""
    /** */
    var slaveAddress:Int64? = 0
    var stove_id:Int64? = 0
    var stove_name:String? = ""
    var value:Double? = 0
}
