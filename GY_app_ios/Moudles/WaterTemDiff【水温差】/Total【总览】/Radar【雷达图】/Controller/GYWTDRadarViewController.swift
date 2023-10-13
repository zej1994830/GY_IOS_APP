//
//  GYWTDRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/27.
//

import UIKit
import DGCharts
import HandyJSON

class GYWTDRadarViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSMutableArray = []
    
    var dataArray:NSArray = []
    var sectionStr:String = ""
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private lazy var Label0:UILabel = {
        let label = UILabel(frame: CGRect(x: 110, y: 0, width: 50, height: 50))
//        label.text = "0°"
        return label
    }()
    
    private lazy var screenLabel:UILabel = {
        let label = UILabel()
        label.text = "筛选："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var screenBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("七进七出", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    private lazy var screenBtn2:UIButton = {
        let btn = UIButton()
        btn.setTitle("入温", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    private lazy var groupLabel:UILabel = {
        let label = UILabel()
        label.text = "组别："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("C1-1、C1-2、C1-3、C1-4", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 185, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 20)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(groupBtnClick), for: .touchUpInside)
        return btn
    }()

    private lazy var queryBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("查询", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        return btn
    }()
    
    
    private lazy var midBgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.alpha = 0.15
        return view
    }()
    
    private lazy var midtitleLabel:UILabel = {
        let label = UILabel()
        label.text = "已选中点"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var midshowview:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F5C105")
        view.label2.text = "C7-S-22-85"
        view.label3.text = "24.58"
        view.label3.snp.remakeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22.5)
            make.top.equalTo(view.label2.snp.bottom).offset(7.5)
        }
        return view
    }()
    
    private lazy var radarCharView:RadarChartView = {
        let view = RadarChartView()
        
//        view.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["0°","90°","180","270°"])
        view.yAxis.drawLabelsEnabled = false
        view.webLineWidth = 0.2
        view.rotationEnabled = false
        view.rotationWithTwoFingers = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        
        requestdata()
    }
    
}

extension GYWTDRadarViewController {
    
    func  setupViews() {
        self.title = "雷达图"
        
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtn)
        bgView.addSubview(screenBtn2)
        bgView.addSubview(groupLabel)
        bgView.addSubview(groupBtn)
        bgView.addSubview(queryBtn)
        bgView.addSubview(midBgView)
        bgView.addSubview(midtitleLabel)
        bgView.addSubview(midshowview)
        bgView.addSubview(radarCharView)
        bgView.addSubview(Label0)
    }
    

    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        screenLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(21)
        }
        
        screenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right).offset(10)
            make.height.equalTo(40)
        }
        
        screenBtn2.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenBtn.snp.right).offset(10)
            make.height.equalTo(40)
        }
        
        groupLabel.snp.makeConstraints { make in
            make.left.height.equalTo(screenLabel)
            make.top.equalTo(screenLabel.snp.bottom).offset(36.5)
        }
        
        groupBtn.snp.makeConstraints { make in
            make.left.height.equalTo(screenBtn)
            make.centerY.equalTo(groupLabel)
        }
        
        queryBtn.snp.makeConstraints { make in
            make.centerY.equalTo(groupLabel)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.width.equalTo(61)
        }
        
        midBgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(groupBtn.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
        
        midtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(midBgView).offset(10)
            make.left.equalTo(midBgView).offset(16)
            make.height.equalTo(21)
        }
        
        midshowview.snp.makeConstraints { make in
            make.left.equalTo(midtitleLabel)
            make.bottom.equalTo(midBgView).offset(-7)
            make.top.equalTo(midtitleLabel.snp.bottom).offset(11)
            make.width.equalTo(105)
        }
        
        radarCharView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(midBgView.snp.bottom).offset(29)
            make.height.equalTo(APP.WIDTH)
        }
    
    }
}

extension GYWTDRadarViewController {
    func requestdata(){
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswclist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["section_list"] as! NSArray
            weakSelf.datatempSectionArray = NSMutableArray(array: weakSelf.dataSectionArray)
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
        
    }
    
    func requestnextdata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partidString = String(format: "%d", dic["id"] as! Int64)
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        screenBtn.setTitle(sectionStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"partidString":partidString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswczonglan, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["temperature_list"] as! NSArray
            weakSelf.radarCharData()
        }
    }
    
    func radarCharData() {
        var entries = [RadarChartDataEntry]()
        for i in 0..<10 {
            let diccc:NSDictionary = dataArray[0] as! NSDictionary
            let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
            let dataModel = GYWTDDataModel.deserialize(from: tempmodel.stove_list[i] as? NSDictionary)
            entries.append(RadarChartDataEntry(value: (dataModel?.inTagValue)!))
        }
    
        let dataSet = RadarChartDataSet(entries: entries, label: "Data")
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.UIColorFromHexvalue(color_vaule: "#ADC6FF")
        let data = RadarChartData(dataSet: dataSet)
        radarCharView.data = data
    }
    
    @objc func groupBtnClick() {
        let vc = GYSelectWaterViewController()
        vc.dataArray = NSMutableArray(array: dataSectionArray)
        vc.tempArray = datatempSectionArray
        vc.titleLabel.text = "组别"
        vc.ClickBlock = { [weak self] array in
            guard let weakSelf = self else {
                return
            }
            weakSelf.datatempSectionArray = NSMutableArray(array: array)
            //拿回来的数组存在顺序错乱，是否排列以后再定
        }
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
}
