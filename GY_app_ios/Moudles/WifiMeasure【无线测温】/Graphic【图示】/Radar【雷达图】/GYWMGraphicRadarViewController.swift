//
//  GYWMGraphicRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/6/5.
//

import UIKit
import AAInfographics

class GYWMGraphicRadarViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSArray = []
    var sectionStr:String = ""
    var dataArray:NSArray = []{
        didSet {
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(lineView)
            }
        }
    }
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 140, bottom: 0, right: -30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
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
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("请选择组别", for: .normal)
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

extension GYWMGraphicRadarViewController {
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
        
        timeBtn.setTitle(String(format: "%@",currentDateString), for: .normal)
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
            make.width.equalTo(160)
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
            make.width.equalTo(200)
            make.top.equalTo(midtimeLabel.snp.bottom).offset(11)
            make.bottom.equalTo(bgView).offset(-7)
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

extension GYWMGraphicRadarViewController {
    func requestdata(){
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":3] as [String:Any]
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
        sectionStr = "请选择组别"
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
            weakSelf.requestlastdata(array: NSArray(objects: weakSelf.dataGroupArray.subarray(with: NSRange(location: 0, length: 5))))
        }
    }
    
    func requestlastdata(array:NSArray) {
        showGroupView.label2.text = ""
        showGroupView.label3.text = ""
        
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
        
        if array.count == 0 {
            GYHUD.show("目前没有组别")
            return
        }
        
        let params = ["device_db":GYDeviceData.default.device_db,"end_time":currentDateString + ":00","idString":stoveidString,"type":2] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getwmchartdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            weakSelf.radarCharData(array: weakSelf.dataArray)
            
        }
    }
    
    func radarCharData(array:NSArray) {
        if array.count == 0 {
            return
        }
        
        var dataEntries = [AASeriesElement]()
        
        var datanameStr = [String]()
        
        
        //默认从正北开始0，所以要多加90
        let angle = 90
        let radius = self.view.frame.size.width / 2 - 25
        for i in 0..<4 {
            let angleInRadians = -CGFloat(angle + 90 * i).truncatingRemainder(dividingBy: 360)
            let x1 = radius * cos(angleInRadians*Double.pi/180)
            let y1 = radius * sin(angleInRadians*Double.pi/180)
            let label = UILabel(frame: CGRect(x: radius + x1, y: radius - y1, width: 35, height: 20))

            label.text = "\(90 * i)°"
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textAlignment = .center
            bgView.addSubview(label)
            
            let selfWidth = lineView.frame.size.width
            let selfHeight = lineView.frame.size.height
            let labelWidth = label.frame.size.width
            let labelHeight = label.frame.size.height
            let view = SBRadarCharts()
            let  p = view.calcCircleCoordinate(withCenter: lineView.center, andWithAngle: CGFloat(angle + 90 * i), andWithRadius: radius)
            if p.x < selfWidth/2 - labelWidth {
                var x = p.x - labelWidth/2
                var y: CGFloat
                if p.y < (selfHeight/2 - labelHeight) {
                    y = p.y - labelHeight/2
                } else {
                    y = p.y + labelHeight/2
                }
                label.center = CGPoint(x: x, y: y)
            } else {
                var x = p.x + labelWidth/2
                var y: CGFloat
                if p.y < (selfHeight/2 - labelHeight) {
                    y = p.y - labelHeight/2
                } else {
                    y = p.y + labelHeight/2
                }
                label.center = CGPoint(x: x, y: y)
            }

            if (p.y > (selfHeight/2 - labelHeight/2) && p.y < (selfHeight/2 + labelHeight/2)) {
                if (p.x < selfWidth/2 - labelHeight) {
                    label.center = CGPoint(x: p.x - labelWidth/2, y: p.y)
                } else {
                    label.center = CGPoint(x: p.x + labelWidth/2, y: p.y)
                }
            } else {
                if (p.x > (selfWidth/2 - labelWidth/2) && p.x < (selfWidth/2 + labelWidth/2)) {
                    if (p.y < selfHeight/2 - labelWidth) {
                        label.center = CGPoint(x: p.x, y: p.y - labelHeight/2)
                    } else {
                        label.center = CGPoint(x: p.x, y: p.y + labelHeight/2)
                    }
                }
            }
        }
        bgView.bringSubviewToFront(namepickView)
        var data = [Any]()
        var data2 = [Any]()
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                return
            }
            
            
            datanameStr.append(tempp["name"] as! String)
            data2.append(tempp["value"] as! Double )
            
            
        }
        
        let gradientColor = AAGradientColor.linearGradient(
            direction: .toLeft,
            startColor: "#ADC6FF",
            endColor: "#ADC6FF"
        )
        
        
        let aa2 = AASeriesElement()
            .name("温度")
            .data(data2)
            .color(gradientColor)
        
        dataEntries.append(aa2)
        
        let model = AAChartModel()
            .polar(true)
            .dataLabelsEnabled(false)
            .categories(datanameStr)
            .margin(right: 30, left: 50)
            .series([
                AASeriesElement()
                    .name(sectionStr)
                    .data(data2)
                    .colorByPoint(true)
            ])
            .chartType(.area)
            
            .tooltipValueSuffix("°C")
//
//            .markerSymbol(.circle)
//            .markerSymbolStyle(.borderBlank)
//            .categories(datanameStr)
            .zoomType(.xy)
        
        lineView.aa_drawChartWithChartModel(model)
        
        
    }
    
    @objc func nameBtnClick() {
        self.view.insertSubview(namepickView, aboveSubview: noDataView)
        namepickView.isHidden = false
    }
    
    @objc func timeBtnClick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: .init(block: {
            BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date2,str2) in
                guard let weakSelf = self else{
                    return
                }
                weakSelf.timeBtn.setTitle(str2!, for: .normal)
                weakSelf.currentDateString = str2!
                weakSelf.requestdata()
            }
        }))
    }
    
    @objc func groupBtnClick() {
        if dataGroupArray.count == 0 {
            GYHUD.show("当前数据没有组别")
            return
        }
        let vc = GYWTDTrendItemsGroupViewController()
        vc.dataArray = dataGroupArray
        vc.tempArray = datatempGroupArray
        vc.iswmbool = true
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

extension GYWMGraphicRadarViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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
        if dataSectionArray.count == 0 {
            return
        }
        requestnextdata(array: [dataSectionArray[row]])
    }
}


extension GYWMGraphicRadarViewController:AAChartViewDelegate {
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
        
        guard let tempp = dataArray[clickEventMessage.index!] as? NSDictionary else {
            return
        }
        
        showGroupView.label2.textAlignment = .left
        showGroupView.label2.snp.remakeConstraints { make in
            make.left.equalTo(showGroupView.label1.snp.right).offset(15)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
        showGroupView.label2.text = (tempp["name"] as! String)
        showGroupView.label3.text = String(format: "%.3f", tempp["value"] as! Double)
        
    }
}
