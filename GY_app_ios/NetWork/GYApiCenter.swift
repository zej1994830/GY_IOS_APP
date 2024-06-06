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
    static let getversion: String = "oauth/version"
    //用户信息
    static let getuserinfo: String = "account/profile"
    //版本更新
    static let getupdataversion: String = "oauth/version"
    //修改密码
    static let posteditpassword: String = "account/EditPassword"
    //轮播图
    static let getbanner: String = "account/GetRotationChart"
    //设备有效期
    static let getdevicetime: String = "account/checkDateInvalid"
    //历史报警
    static let getListHistoryData:String = "alarm/ListHistoryData"
    //实时报警
    static let getListTimeData:String = "alarm/ListTimeData"
    //获取实时报警监控信息
    static let getMonitorData:String = "alarm/Monitor"
    //获取首页展示项
    static let getfunctionflag:String = "group/getfunctionflag"
}

extension Api {
    //段列表 0:温差 1:炉壳 2:热电偶 3:无线测温 4:风口套测温 5:热风炉 6:煤枪
    static let getswclist: String = "group/getsectionlist"
    //水温差总览
    static let getswczonglan: String = "wcpandect/getwcindextaglistbypart"
    //水温差趋势
    static let getswctrend: String = "wcpandect/getWCHistroyByGroupId"
    //水温差数据
    static let getswcdata: String = "wcpandect/getwcgrouptagdatlist"
    //温差 入温 出温 流量 热流趋势
    static let getGroupDataListByPartId: String = "wcdiagram/getGroupDataListByPartId"
    //水温差_趋势_获取高炉分段详细数据接口
    static let getswctrenddata: String = "wctrend/getwctrenddata"
    //数据 月日时分
    static let getwctimedata: String = "wctime/getwctimedata"
    //设备巡检 信息接口
    static let getdeviceaddresslist: String = "devicechecker/getdeviceaddresslists"
    //设备巡检 TAGList接口
    static let gettaglistbydeviceaddr: String = "devicechecker/gettaglistbydeviceaddr"
}

extension Api {
    //炉壳温度总览 getfmindextaglistbypart
    static let getlkzonglan: String = "fmpandect/getfmindextaglistbypart"
    //炉壳温度总览柱状图
    static let getlkzonglanzhuzhuangtu: String = "fmpandect/getfmindexpartgrouplist"
    //炉壳测温趋势曲线数据
    static let getlktrend: String = "FMDiagram/GetTrendChartData"
    //炉壳测温图示柱状图雷达图
    static let getlkgraphicbarorradar: String = "FMDiagram/GetChartData"
    //炉壳测温_分时数据接口
    static let getlkfmtimedata: String = "fmtime/getfmtimedata"
    //获取炉壳测温趋势曲线数据
    static let getlkTrendChartData: String = "FMDiagram/GetTrendChartData"
    //获取高炉温差分段标签接口 雷达图
    static let getlkGroupListByPartId: String = "group/getGroupListByPartId"
}

extension Api {
    //热电偶标高
    static let getrdobiaogao: String = "group/GetBFGroupList"
    //获取指定段位的热点偶列表信息
    static let getrdobiaogaoduanwei: String = "group/GetBFTagList"
    //热电偶实时数据
    static let getrdorealdata: String = "TCRealData/GetTimeData"
    //获取实时热电偶历史曲线数据
    static let getrdorealhistorychartdata: String = "TCRealData/gethistorychartdata"
    //热电偶历史数据
    static let getrdohistorydata: String = "TCHistoryData/GetHistoryData"
    //获取历史热电偶历史曲线数据
    static let getrdohistorychartdata: String = "TCHistoryData/GetHistoryChartData"
}

extension Api {
    //获取高炉历史形貌所有有数据的时间点接口
    static let getqsjhhistorytimenode: String = "etpandect/getethistorytimenode"
    //获取高炉轴截面方位或横截面标高接口
    static let getqsjhdirectionorlevellist: String = "etpandect/getdirectionorlevellist"
    //获取高炉历史形貌所有有数据接口
    static let getqsjhHistoryTimeData: String = "etpandect/getETHistoryTimeData"
    //获取高炉侵蚀形貌详细数据接口
    static let getqsjhortempdata: String = "etpandect/getetortempdata"
    //获取高炉侵蚀结厚数据结果接口
    static let getqsjhdirectiondataresult: String = "etpandect/getdirectiondataresult"
    //侵蚀立体形貌显示
    static let getqsjhGraph3D: String = "etpandect/getETGraph3D"
}

extension Api {
    //获取无线测温总览
    static let getwxcwzonglan: String = "cwsnpandect/getcwsnindextaglistbypart"
    //获取历史曲线
    static let getcwsntaghistroyby:String = "cwsnpandect/getcwsntaghistroybyid"
    //无线测温 柱状图
    static let getcwsngrouplistdata = "cwsnpandect/getcwsngrouplistdatabypartid"
    //获取指定段位的无线测温设备列表信息
    static let getBFLsTagList = "group/GetBFLsTagList"
    //无线测温图示趋势
    static let gettrendchartdata = "cwsndiagram/gettrendchartdata"
    //无线测温图示柱状图
    static let getwmchartdata = "cwsndiagram/getchartdata"
    
}
