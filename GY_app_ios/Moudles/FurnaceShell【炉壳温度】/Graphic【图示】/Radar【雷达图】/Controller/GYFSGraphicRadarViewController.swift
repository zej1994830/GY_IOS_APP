//
//  GYFSGraphicRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/1/2.
//

import UIKit
import AAInfographics

class GYFSGraphicRadarViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSArray = []
    var sectionStr:String = ""
    var dataArray:NSArray = []
    var dataGroupArray:NSArray = []
    var datatempGroupArray:NSMutableArray = []
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = "段名："
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间："
        return label
    }()
    
    private lazy var groupLabel:UILabel = {
        let label = UILabel()
        label.text = "组别："
        return label
    }()
    
    private lazy var nameBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("一进一出", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_rili"), for: .normal)
        btn.setTitle("2023-04-16 14:43 至 2023-04-18 14:43", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 110, bottom: 0, right: -50)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 325 - APP.WIDTH, bottom: 0, right: 10)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("C1-1、C1-2、C1-3、C1-4、C1-5", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 110, bottom: 0, right: -50)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 285 - APP.WIDTH, bottom: 0, right: 15)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(groupBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - 中视图
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        view.alpha = 0.15
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var midtimeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间：2022-04-19 10:36"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var showGroupView:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#BC7DFC")
        view.label2.text = "C1-1"
        view.label3.text = "0.07"
        return view
    }()
    
    private lazy var lineView:AAChartView = {
        let view = AAChartView()
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    
    private lazy var namepickView:UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.isHidden = true
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
        requestdata()
    }

}

extension GYFSGraphicRadarViewController {
    func setupViews() {
        self.title = "雷达图"
        self.view.addSubview(headView)
        headView.addSubview(nameLabel)
        headView.addSubview(nameBtn)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(groupLabel)
        headView.addSubview(groupBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(bgView)
        midView.addSubview(midtimeLabel)
        midView.addSubview(showGroupView)
        midView.addSubview(lineView)
        self.view.addSubview(namepickView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
        
        timeBtn.setTitle(String(format: "%@ 至 %@", currentLastHourDateString,currentDateString), for: .normal)
    }
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(105)
            make.left.equalTo(nameLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.height.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(36.5)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
            make.left.equalTo(timeLabel.snp_rightMargin).offset(10)
        }
        
        groupLabel.snp.makeConstraints { make in
            make.left.height.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(36.5)
        }
        
        groupBtn.snp.makeConstraints { make in
            make.centerY.equalTo(groupLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12.5)
            make.left.equalTo(groupLabel.snp_rightMargin).offset(10)
        }
        
        midView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(headView.snp.bottom).offset(5)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(100)
        }
        
        midtimeLabel.snp.makeConstraints { make in
            make.left.equalTo(15.5)
            make.top.equalTo(20)
        }
        
        showGroupView.snp.makeConstraints { make in
            make.left.equalTo(midtimeLabel)
            make.width.equalTo(60)
            make.top.equalTo(midtimeLabel.snp.bottom).offset(11)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.bottom.equalTo(-115)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}

extension GYFSGraphicRadarViewController {
    func requestdata(){
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":1] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswclist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["section_list"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            weakSelf.datatempSectionArray = [weakSelf.dataSectionArray.firstObject as Any]
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
        
    }
    func requestnextdata(array:NSArray){
        var partid:Int32 = 0
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partid = dic["id"] as! Int32
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        nameBtn.setTitle(sectionStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"partId":partid] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getlkGroupListByPartId, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataGroupArray = dicc["temperature_list"] as! NSArray
            weakSelf.requestlastdata(array: NSArray(objects: weakSelf.dataGroupArray.suffix(5)))
        }
    }
    
    func requestlastdata(array:NSArray) {
        datatempGroupArray = NSMutableArray(array: array)
        var namestr:String = ""
        var stoveidString:String = ""
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                return
            }
            
            if namestr.count == 0 {
                namestr = tempp["name"] as! String
            }else {
                namestr = namestr + "," + (tempp["name"] as! String)
            }
            
            let id:Int64 = tempp["id"] as! Int64
            let idstr = String(format: "%d", id)
            if stoveidString.count == 0 {
                stoveidString = idstr
            }else {
                stoveidString = stoveidString + "," + idstr
            }
        }
        groupBtn.setTitle(namestr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00","idString":stoveidString,"type":2] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getlkgraphicbarorradar, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["data"] as! NSArray
            weakSelf.radarCharData(array: weakSelf.dataArray)
            
        }
    }
    
    func radarCharData(array:NSArray) {
        let dic:NSDictionary = array.firstObject as! NSDictionary
        let firstmodel = GYFSDataModel.deserialize(from: dic)!
        let data:NSMutableArray = []
        let categories:NSMutableArray = []
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                return
            }
            
            data.add(tempp["value"] ?? 0)
            categories.add(tempp["stove_name"])
        }
        
        let model = AAChartModel()
            .chartType(.area)
            .colorsTheme(["#EA173D"])
            .animationType(.easeOutCubic)
            .animationDuration(1200)
            .zoomType(.x)
            .series([
                AASeriesElement()
                    .name(firstmodel.partName!)
                    .data(data as! [Any])
                    .allowPointSelect(true)
                    .states(AAStates()
                        .select(AASelect()
                            .color("#BB1231")))
                    
            ])
            .categories(categories as! [String])
            .tooltipEnabled(true)
        
        lineView.aa_drawChartWithChartModel(model)
        
        
    }
    
    @objc func nameBtnClick() {
        namepickView.isHidden = false
    }
    
    @objc func timeBtnClick() {
        BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { (date,str) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: .init(block: {
                BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date,str2) in
                    guard let weakSelf = self else{
                        return
                    }
//                    let startIndex = str2!.index(str2!.startIndex, offsetBy: 5)
                    weakSelf.timeBtn.setTitle(str! + " 至 " + str2!, for: .normal)
                    weakSelf.currentDateString = str2!
                    weakSelf.currentLastHourDateString = str!
                    weakSelf.requestdata()
                }
            }))
            
        }
    }
    
    @objc func groupBtnClick() {
        let vc = GYWTDTrendItemsGroupViewController()
        vc.dataArray = dataGroupArray
        vc.tempArray = datatempGroupArray
        vc.ClickBlock = {[weak self] array in
            guard let weakSelf = self else {
                return
            }
            weakSelf.requestlastdata(array: array)
        }
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
}

extension GYFSGraphicRadarViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSectionArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
        return (dic["name"] as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        requestnextdata(array: [dataSectionArray[row]])
    }
}


extension GYFSGraphicRadarViewController:AAChartViewDelegate {
    open func aaChartView(_ aaChartView: AAChartView, clickEventMessage: AAClickEventMessageModel) {
        print(
            """

            clicked point series element name: \(clickEventMessage.name ?? "")
            🖱🖱🖱WARNING!!!!!!!!!!!!!!!!!!!! Click Event Message !!!!!!!!!!!!!!!!!!!! WARNING🖱🖱🖱
            ==========================================================================================
            ------------------------------------------------------------------------------------------
            user finger CLICKED!!!,get the custom click event message: {
            category = \(String(describing: clickEventMessage.category))
            index = \(String(describing: clickEventMessage.index))
            name = \(String(describing: clickEventMessage.name))
            offset = \(String(describing: clickEventMessage.offset))
            x = \(String(describing: clickEventMessage.x))
            y = \(String(describing: clickEventMessage.y))
            }
            +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            
            """
        )
        
        showGroupView.label2.text = String(describing: clickEventMessage.name)
        showGroupView.label3.text = String(describing: clickEventMessage.x)
        
    }
}
