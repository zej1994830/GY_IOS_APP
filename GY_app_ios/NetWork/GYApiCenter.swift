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
    //历史报警
    static let getListHistoryData:String = "alarm/ListHistoryData"
    //实时报警
    static let getListTimeData:String = "alarm/ListTimeData"
    
}

extension Api {
    //水温差段列表
    static let getswclist: String = "group/getsectionlist"
    //水温差总览
    static let getswczonglan: String = "wcpandect/getwcindextaglistbypart"
    //水温差趋势
    static let getswctrend: String = "wcpandect/getWCHistroyByGroupId"
    //水温差数据
    static let getswcdata: String = "wcpandect/getwcgrouptagdatlist"
    //温差 入温 出温 流量 热流趋势
    static let getGroupDataListByPartId: String = "wcpandect/getGroupDataListByPartId"
    //数据 月日时分
    static let getwctimedata: String = "wctime/getwctimedata"
    //设备巡检 信息接口
    static let getdeviceaddresslist: String = "devicechecker/getdeviceaddresslist"
    //设备巡检 TAGList接口
    static let gettaglistbydeviceaddr: String = "devicechecker/gettaglistbydeviceaddr"
}

