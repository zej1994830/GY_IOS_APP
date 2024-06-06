//
//  GYWMModel.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/5/29.
//

import UIKit
import HandyJSON

class GYWMModel: HandyJSON {
    required init() { }
}

struct GYWMDataModel:HandyJSON {
    /**当前分段中标签编号*/
    var name:String? = ""
    var id:Int64? = 0
    var countABC:Int64? = 0
    var countD:Int64? = 0
    
    var A1_Name:String? = ""
    var A1_value:Double? = 0
    var A1_exception:Int64? = 0
    var A1_MA:Int64? = 0
    var A1_SA:Int64? = 0
    var A1_L:Int64? = 0
    var A1_LL:Int64? = 0
    var A1_H:Int64? = 0
    var A1_HH:Int64? = 0
    var A1_tempValue:Int64? = 0
    
    var A2_Name:String? = ""
    var A2_value:Double? = 0
    var A2_exception:Int64? = 0
    var A2_MA:Int64? = 0
    var A2_SA:Int64? = 0
    var A2_L:Int64? = 0
    var A2_LL:Int64? = 0
    var A2_H:Int64? = 0
    var A2_HH:Int64? = 0
    var A2_tempValue:Int64? = 0
    
    var A3_Name:String? = ""
    var A3_value:Double? = 0
    var A3_exception:Int64? = 0
    var A3_MA:Int64? = 0
    var A3_SA:Int64? = 0
    var A3_L:Int64? = 0
    var A3_LL:Int64? = 0
    var A3_H:Int64? = 0
    var A3_HH:Int64? = 0
    var A3_tempValue:Int64? = 0

    var B1_Name:String? = ""
    var B1_value:Double? = 0
    var B1_exception:Int64? = 0
    var B1_MA:Int64? = 0
    var B1_SA:Int64? = 0
    var B1_L:Int64? = 0
    var B1_LL:Int64? = 0
    var B1_H:Int64? = 0
    var B1_HH:Int64? = 0
    var B1_tempValue:Int64? = 0
    
    var B2_Name:String? = ""
    var B2_value:Double? = 0
    var B2_exception:Int64? = 0
    var B2_MA:Int64? = 0
    var B2_SA:Int64? = 0
    var B2_L:Int64? = 0
    var B2_LL:Int64? = 0
    var B2_H:Int64? = 0
    var B2_HH:Int64? = 0
    var B2_tempValue:Int64? = 0
    
    var B3_Name:String? = ""
    var B3_value:Double? = 0
    var B3_exception:Int64? = 0
    var B3_MA:Int64? = 0
    var B3_SA:Int64? = 0
    var B3_L:Int64? = 0
    var B3_LL:Int64? = 0
    var B3_H:Int64? = 0
    var B3_HH:Int64? = 0
    var B3_tempValue:Int64? = 0
    
    var C1_Name:String? = ""
    var C1_value:Double? = 0
    var C1_exception:Int64? = 0
    var C1_MA:Int64? = 0
    var C1_SA:Int64? = 0
    var C1_L:Int64? = 0
    var C1_LL:Int64? = 0
    var C1_H:Int64? = 0
    var C1_HH:Int64? = 0
    var C1_tempValue:Int64? = 0
    
    var C2_Name:String? = ""
    var C2_value:Double? = 0
    var C2_exception:Int64? = 0
    var C2_MA:Int64? = 0
    var C2_SA:Int64? = 0
    var C2_L:Int64? = 0
    var C2_LL:Int64? = 0
    var C2_H:Int64? = 0
    var C2_HH:Int64? = 0
    var C2_tempValue:Int64? = 0
    
    var C3_Name:String? = ""
    var C3_value:Double? = 0
    var C3_exception:Int64? = 0
    var C3_MA:Int64? = 0
    var C3_SA:Int64? = 0
    var C3_L:Int64? = 0
    var C3_LL:Int64? = 0
    var C3_H:Int64? = 0
    var C3_HH:Int64? = 0
    var C3_tempValue:Int64? = 0
    
    var D1_Name:String? = ""
    var D1_value:Double? = 0
    var D1_exception:Int64? = 0
    var D1_MA:Int64? = 0
    var D1_SA:Int64? = 0
    var D1_L:Int64? = 0
    var D1_LL:Int64? = 0
    var D1_H:Int64? = 0
    var D1_HH:Int64? = 0
    var D1_tempValue:Int64? = 0
    
    var D2_Name:String? = ""
    var D2_value:Double? = 0
    var D2_exception:Int64? = 0
    var D2_MA:Int64? = 0
    var D2_SA:Int64? = 0
    var D2_L:Int64? = 0
    var D2_LL:Int64? = 0
    var D2_H:Int64? = 0
    var D2_HH:Int64? = 0
    var D2_tempValue:Int64? = 0
    
    var D3_Name:String? = ""
    var D3_value:Double? = 0
    var D3_exception:Int64? = 0
    var D3_MA:Int64? = 0
    var D3_SA:Int64? = 0
    var D3_L:Int64? = 0
    var D3_LL:Int64? = 0
    var D3_H:Int64? = 0
    var D3_HH:Int64? = 0
    var D3_tempValue:Int64? = 0
    
    var D4_Name:String? = ""
    var D4_value:Double? = 0
    var D4_exception:Int64? = 0
    var D4_MA:Int64? = 0
    var D4_SA:Int64? = 0
    var D4_L:Int64? = 0
    var D4_LL:Int64? = 0
    var D4_H:Int64? = 0
    var D4_HH:Int64? = 0
    var D4_tempValue:Int64? = 0
    
    var D5_Name:String? = ""
    var D5_value:Double? = 0
    var D5_exception:Int64? = 0
    var D5_MA:Int64? = 0
    var D5_SA:Int64? = 0
    var D5_L:Int64? = 0
    var D5_LL:Int64? = 0
    var D5_H:Int64? = 0
    var D5_HH:Int64? = 0
    var D5_tempValue:Int64? = 0
}
