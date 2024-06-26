//
//  GYWTDTotalData.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/15.
//

import UIKit
import HandyJSON

class GYWTDTotalData: HandyJSON {
    required init() { }
}

struct GYWTDBaseModel:HandyJSON {
    var section_id:Int64 = 0
    
    var stove_list:NSArray = []
    var section_name:String = ""
}


struct GYWTDDataModel:HandyJSON{
    /**当前分段中标签编号*/
    var name:String = ""
    /**当前分段中标签id*/
    var id:Int64 = 0
    /**0：无流量计，1：有流量计*/
    var flagFlowMeter:Int64 = 0
    /**入水温度标签域名 */
    var inTagFieldName:String = ""
    /**入水温度标签名称 */
    var inTagName:String = ""
    /**入水温度 */
    var inTagValue:Double = 0
    /**入水温度标签主机地址 */
    var inTagMasterAddress:String = ""
    /**入水温度标签子机地址 */
    var inTagTagSlaveAddress:String = ""
    /**出水温度标签域名 */
    var outTagFieldName:String = ""
    /**出水温度标签名称 */
    var outTagName:String = ""
    /**出水温度 */
    var outTagValue:Double = 0
    /**出水温度标签主机地址 */
    var outTagMasterAddress:String = ""
    /**出水温度标签子机地址 */
    var outTagTagSlaveAddress:String = ""
    /**流量标签域名 */
    var flowTagFieldName:String = ""
    /**流量标签名称 */
    var flowTagName:String = ""
    /**流量  kg*/
    var flowTagValue:Double = 0
    /**流量  t*/
    var flowTagTValue:Double {
        get{
            return (flowTagValue ?? 0) / 1000
        }
    }
    /**流量标签主机地址 */
    var flowTagMasterAddress:String = ""
    /**流量标签子机地址 */
    var flowTagSlaveAddress:String = ""
    /**温差低低报警 */
    var lL_WC:Int64 = 0
    /**温差低报警 */
    var l_WC:Int64 = 0
    /**温差高报警 */
    var h_WC:Int64 = 0
    /**温差高高报警 */
    var hH_WC:Int64 = 0
    /**热流低低报警 */
    var lL_RL:Int64 = 0
    /**热流低报警 */
    var l_RL:Int64 = 0
    /**热流高报警 */
    var h_RL:Int64 = 0
    /**热流高高报警 */
    var hH_RL:Int64 = 0
    /**流量低低报警 */
    var lL_LL:Int64 = 0
    /**流量低报警 */
    var l_LL:Int64 = 0
    /**流量高报警 */
    var h_LL:Int64 = 0
    /**流量高高报警 */
    var hH_LL:Int64 = 0
    /**入水温度低低报警 */
    var lL_In:Int64 = 0
    /**入水温度低报警 */
    var l_In:Int64 = 0
    /**入水温度高报警 */
    var h_In:Int64 = 0
    /**入水温度高高报警 */
    var hH_In:Int64 = 0
    /**出水温度低低报警 */
    var lL_Out:Int64 = 0
    /**出水温度流量低报警 */
    var l_Out:Int64 = 0
    /**出水温度高报警 */
    var h_Out:Int64 = 0
    /**出水温度高高报警 */
    var hH_Out:Int64 = 0
    /**冷却面积 */
    var area:String = ""
    /**当前段名称 */
    var section_name:String = ""
    /**入水温度表 */
    var inTagTableName:String = ""
    /**出水温度表 */
    var outTagTableName:String = ""
    /**流量表 */
    var flowtTagTableName:String = ""
    /**内流量表 */
    var inFlowTagTableName:String = ""
    /**热流 */
    var reFlowTagValue:Double = 0
    /**温差 */
    var wcValue:Double = 0
    /**温差异常 */
    var wcException:Int64 = 0
    /**热流异常 */
    var rlException:Int64 = 0
    /**流量异常 */
    var llException:Int64 = 0
}
