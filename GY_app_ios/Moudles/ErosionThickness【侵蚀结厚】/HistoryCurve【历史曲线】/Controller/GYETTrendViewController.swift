//
//  GYETTrendViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/2/4.
//

import UIKit
import AAInfographics

class GYETTrendViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var datapositionArray:NSArray = []
    var datanumberArray:NSArray = []
    var dataArray:NSArray = []
    var dataImgArray:NSArray = []
    var position:Int64 = 1
    var number:Int64 = 1
    
    private lazy var bgView:UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.bounces = false
        return view
    }()
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间："
        return label
    }()
    
    private lazy var positionLabel:UILabel = {
        let label = UILabel()
        label.text = "方位："
        return label
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
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var positionBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("方位｜方位1", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 130, bottom: 0, right: -100)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(positionBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var numberBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("编号｜1", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: -30)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(numberBtnBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - 中视图
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bgmidView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        view.alpha = 0.15
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var midLabel:UILabel = {
        let label = UILabel()
        label.text = "已选中点"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var showGroupView:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#BC7DFC")
        view.label2.text = ""
        view.label3.text = ""
        return view
    }()
    
    private lazy var lineView:AAChartView = {
        let view = AAChartView()
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    
    private lazy var scatterimageV:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var circularimageV:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var positionpickView:UIPickerView = {
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
    
    private lazy var numberpickView:UIPickerView = {
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

extension GYETTrendViewController {
    func setupViews() {
        self.title = "历史曲线"
        self.view.addSubview(bgView)
        bgView.addSubview(headView)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(positionLabel)
        headView.addSubview(positionBtn)
        headView.addSubview(numberBtn)
        
        bgView.addSubview(midView)
        midView.addSubview(bgmidView)
        midView.addSubview(midLabel)
        midView.addSubview(showGroupView)
        midView.addSubview(lineView)
        midView.addSubview(scatterimageV)
        midView.addSubview(circularimageV)
        self.view.addSubview(positionpickView)
        self.view.addSubview(numberpickView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(topHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        headView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(5)
            make.width.equalTo(APP.WIDTH)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
            make.left.equalTo(timeLabel.snp_rightMargin).offset(10)
        }
        
        positionLabel.snp.makeConstraints { make in
            make.left.height.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(36.5)
        }
        
        positionBtn.snp.makeConstraints { make in
            make.centerY.equalTo(positionLabel)
            make.height.equalTo(40)
            make.bottom.equalTo(-12.5)
            make.left.equalTo(positionLabel.snp_rightMargin).offset(10)
            make.width.equalTo(150)
        }
        
        numberBtn.snp.makeConstraints { make in
            make.centerY.equalTo(positionLabel)
            make.height.equalTo(40)
            make.left.equalTo(positionBtn.snp_rightMargin).offset(20)
            make.width.equalTo(100)
        }
        
        midView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
        bgmidView.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(100)
        }
        
        midLabel.snp.makeConstraints { make in
            make.left.equalTo(26)
            make.top.equalTo(20)
        }
        
        showGroupView.snp.makeConstraints { make in
            make.top.equalTo(midLabel.snp.bottom).offset(11)
            make.left.equalTo(midLabel)
            make.width.equalTo(200)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(bgmidView)
            make.top.equalTo(bgmidView.snp.bottom).offset(20)
            make.height.equalTo(APP.WIDTH)
        }
        
        scatterimageV.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.right.equalTo(0)
        }

        circularimageV.snp.makeConstraints { make in
            make.top.equalTo(scatterimageV.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH / 4 * 3)
            make.bottom.equalTo(0)
        }

        
        positionpickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        numberpickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func timeBtnClick() {
        BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { (date1,str) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: .init(block: {
                BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date2,str2) in
                    guard let weakSelf = self else{
                        return
                    }
                    if date1! > date2! {
                        GYHUD.show("开始时间不能大于结束时间")
                        return
                    }
                    weakSelf.timeBtn.setTitle(str! + " 至 " + str2!, for: .normal)
                    weakSelf.currentDateString = str2!
                    weakSelf.currentLastHourDateString = str!
                    weakSelf.requestlastdata()
                }
            }))
            
        }
    }

    @objc func positionBtnClick() {
        positionpickView.isHidden = false
        numberpickView.isHidden = true
    }

    @objc func numberBtnBtnClick() {
        positionpickView.isHidden = true
        numberpickView.isHidden = false
    }

    
}


extension GYETTrendViewController:AAChartViewDelegate {
    func requestdata() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhdirectionorlevellist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.datapositionArray = dicc["data"] as! NSArray
            weakSelf.requestnextdata()
        }
//        getqsjhHistoryTimeData
    }
    
    func requestnextdata() {
        let params = ["device_db":GYDeviceData.default.device_db,"type":2] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhdirectionorlevellist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.datanumberArray = dicc["data"] as! NSArray
            let diccc:NSDictionary = weakSelf.datapositionArray.firstObject as! NSDictionary
            weakSelf.position = diccc["stove_id"] as! Int64
            let dicccc:NSDictionary = weakSelf.datanumberArray.firstObject as! NSDictionary
            weakSelf.number = dicccc["stove_id"] as! Int64
            weakSelf.positionpickView.reloadAllComponents()
            weakSelf.numberpickView.reloadAllComponents()
            weakSelf.requestlastdata()
        }
    }
    
    func requestlastdata() {
        let params = ["device_db":GYDeviceData.default.device_db,"direction":position,"number":number,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00"] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhHistoryTimeData, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["histroy"] as! NSArray
            weakSelf.dataImgArray = dicc["data"] as! NSArray
            weakSelf.radarCharData(array: weakSelf.dataArray)
            weakSelf.updateImageV()
        }
    }
    
    func updateImageV() {
        let dic:NSDictionary = dataImgArray.firstObject as! NSDictionary
        let scastr:String = dic["dimg"] as! String
        let cirstr:String = dic["rimg"] as! String
        scatterimageV.image = UIImage(data: Data(base64Encoded: scastr)!)
        circularimageV.image = UIImage(data: Data(base64Encoded: cirstr)!)
    }
    
    func radarCharData(array:NSArray) {
        var dataEntries = [AASeriesElement]()
//        let labelarray = groupBtn.titleLabel?.text?.components(separatedBy: ",")
        var categories = [String]()
        var data = [Any]()
        for j in 0..<array.count {
            let tempdic = array[j] as! NSDictionary
            categories.append(tempdic["date"]! as! String)
            data.append(tempdic["slag_thickness"] as Any)
        }
        let aa = AASeriesElement()
            .name("残余厚度")
            .data(data)
        dataEntries.append(aa)
        
        let chartmodel = AAChartModel()
            .chartType(.line)
            .colorsTheme(["#EA173D"])
            .xAxisLabelsStyle(AAStyle(color: AAColor.black,fontSize: 14))
            .dataLabelsEnabled(false)
            .animationType(.bounce)
            .series(dataEntries)
            .markerSymbolStyle(.borderBlank)
            .markerRadius(0)
            .categories(categories)
            .markerSymbol(.circle)
            .zoomType(.x)//缩放功能
            .legendEnabled(true)
        lineView.aa_drawChartWithChartModel(chartmodel)
    }
    
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
        let tempdic = dataArray[clickEventMessage.index!] as! NSDictionary
        showGroupView.label2.text = (tempdic["date"]! as! String)
        showGroupView.label3.text = String(format: "%d", tempdic["slag_thickness"] as! Int64)
        
    }
}

extension GYETTrendViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == positionpickView {
            return datapositionArray.count
        }else{
            return datanumberArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == positionpickView {
            if let dic:NSDictionary = datapositionArray[row] as? NSDictionary {
                return (dic["stove_name"] as! String)
            }
        }else{
            if let dic:NSDictionary = datanumberArray[row] as? NSDictionary {
                return (dic["stove_name"] as! String)
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        if pickerView == positionpickView {
            if datapositionArray.count == 0 {
                return
            }
            if let dic:NSDictionary = datapositionArray[row] as? NSDictionary {
                position = dic["stove_id"] as! Int64
                positionBtn.setTitle(NSString(format: "方位｜%@", dic["stove_name"] as! CVarArg) as String, for: .normal)
            }
        }else{
            if datanumberArray.count == 0 {
                return
            }
            if let dic:NSDictionary = datanumberArray[row] as? NSDictionary {
                number = dic["stove_id"] as! Int64
                numberBtn.setTitle(NSString(format: "编号｜%@", dic["stove_name"] as! CVarArg) as String, for: .normal)
            }
        }
        pickerView.isHidden = true
        requestlastdata()
    }
}
