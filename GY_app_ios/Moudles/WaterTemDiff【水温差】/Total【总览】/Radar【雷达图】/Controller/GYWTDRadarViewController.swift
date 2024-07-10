//
//  GYWTDRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/27.
//

import UIKit
import AAInfographics

class GYWTDRadarViewController: GYViewController {
    var oricontentoffset:CGPoint = CGPoint(x: 0, y: 0)
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSMutableArray = []
    let labelarray = ["温差","入温","出温","流量","热流"]
    var nameStr:String = "温差"
    var typeString:Int = 1
    var tempmodel:GYWTDRadarModel = GYWTDRadarModel(){
        didSet {
            noDataView.isHidden = tempmodel.stove_lists.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(radarCharView)
            }
        }
    }
    
    var dataArray:NSArray = []
    var sectionStr:String = ""
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 150, bottom: 0, right: -30)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(screenBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var screenBtn2:UIButton = {
        let btn = UIButton()
        btn.setTitle("温差", for: .normal)
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
        btn.addTarget(self, action: #selector(screenBtn2Click), for: .touchUpInside)
        return btn
    }()
    
    private lazy var screenBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        
        view.title = ""
        view.titleColor = .black
        view.titleBgColor = .white
        view.rotateIcon = UIImage(named: "ic_arrow_blue")!
        view.rotateIconSize = CGSize(width: 10, height: 7)
        view.titleFont = UIFont.systemFont(ofSize: 15)
        view.optionFont = view.titleFont
        view.optionBgColor = .white
        view.optionLineColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD")
        view.optionTextColor = .black
        view.showsVerticalScrollIndicatorOfOptionsList = false
        view.optionsListLimitHeight = 200
        return view
    }()
    
    private lazy var wenchaBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        
        view.title = "温差"
        view.titleColor = .black
        view.titleBgColor = .white
        view.rotateIcon = UIImage(named: "ic_arrow_blue")!
        view.rotateIconSize = CGSize(width: 10, height: 7)
        view.titleFont = UIFont.systemFont(ofSize: 15)
        view.optionFont = view.titleFont
        view.optionBgColor = .white
        view.optionLineColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD")
        view.optionTextColor = .black
        view.showsVerticalScrollIndicatorOfOptionsList = false
        return view
    }()
    
    private lazy var groupLabel:UILabel = {
        let label = UILabel()
        label.text = "组别："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("请选择组别", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 255, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
//        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 20)
        btn.contentHorizontalAlignment = .left
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
        btn.addTarget(self, action: #selector(queryBtnClick), for: .touchUpInside)
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
        view.label2.text = ""
        view.label3.text = ""
        view.label3.snp.remakeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22.5)
            make.top.equalTo(view.label2.snp.bottom).offset(7.5)
        }
        return view
    }()
    
    private lazy var radarCharView:AAChartView = {
        let view = AAChartView()
        view.delegate = self as AAChartViewDelegate
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var scrollView:UIScrollView = {
        let view = UIScrollView()
        view.contentSize = CGSize(width: APP.WIDTH * 2, height: APP.WIDTH * 3)
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.delegate = self
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 4.0
        return view
    }()
    
    private lazy var radarView:GYWTDRadarView = {
        let view = GYWTDRadarView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var namepickView:UIPickerView = {//废弃
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
    
    private lazy var  namepickView2:UIPickerView = {//废弃
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
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        oricontentoffset = scrollView.contentOffset
    }
    
}

extension GYWTDRadarViewController {
    
    func  setupViews() {
        self.title = "雷达图"
        
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtnMenu)
        bgView.addSubview(wenchaBtnMenu)
        bgView.addSubview(groupLabel)
        bgView.addSubview(groupBtn)
        bgView.addSubview(queryBtn)
        bgView.addSubview(midBgView)
        bgView.addSubview(midtitleLabel)
        bgView.addSubview(midshowview)
        bgView.addSubview(radarCharView)
        bgView.addSubview(scrollView)
        scrollView.addSubview(radarView)
        
        bgView.addSubview(namepickView)
        bgView.addSubview(namepickView2)
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
            make.width.equalTo(50)
        }
        
        screenBtnMenu.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(170)
        }
        
        wenchaBtnMenu.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenBtnMenu.snp.right).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        groupLabel.snp.makeConstraints { make in
            make.left.height.equalTo(screenLabel)
            make.top.equalTo(screenLabel.snp.bottom).offset(36.5)
            make.width.equalTo(50)
        }
        
        groupBtn.snp.makeConstraints { make in
            make.left.height.equalTo(screenBtnMenu)
            make.centerY.equalTo(groupLabel)
            make.right.equalTo(queryBtn.snp.left).offset(-15)
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
            make.width.equalTo(80)
        }
        
        radarCharView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(midBgView.snp.bottom).offset(29)
            make.height.equalTo(APP.WIDTH)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(midBgView.snp.bottom)
            make.height.equalTo(APP.WIDTH * 1.4)
        }
        
        radarView.snp.makeConstraints { make in
            make.height.equalTo(APP.WIDTH - 60)
            make.width.equalTo(APP.WIDTH - 60)
            make.centerX.equalTo(scrollView.contentSize.width / 2)
            make.centerY.equalTo(scrollView.contentSize.height / 2)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        namepickView2.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension GYWTDRadarViewController {
    func requestdata(){
        
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswclist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["section_list"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            weakSelf.requestdata2(array: weakSelf.dataSectionArray)
        }
        
    }
    
    func requestdata2(array:NSArray){
        var partid:Int32 = 0
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partid = dic["id"] as! Int32
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        screenBtnMenu.title = sectionStr
        let params = ["device_db":GYDeviceData.default.device_db,"partId":partid,"type":typeString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getGroupDataListByPartId, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["temperature_list"] as! NSArray
            weakSelf.datatempSectionArray = NSMutableArray.init(array: weakSelf.dataArray.subarray(with: NSRange(location: 0, length: 5)))
            weakSelf.requestnextdata(array: NSArray(objects: weakSelf.dataArray.subarray(with: NSRange(location: 0, length: 5))))
        }
    }
    
    func requestnextdata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        var datanameStr:String = ""
        for i in 0..<array.count {
            let dic:NSDictionary = array[i] as! NSDictionary
            
            if i == 0 {
                datanameStr = String(format: "%@", dic["name"] as! String)
                partidString = String(format: "%d", dic["id"] as! Int64)
            }else{
                datanameStr = datanameStr + "，" + String(format: "%@", dic["name"] as! String)
                partidString = partidString + "," + String(format: "%d", dic["id"] as! Int64)
            }
        }
        //段名
        groupBtn.setTitle(datanameStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"partidString":partidString,"rate":"2","typeString":typeString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswcdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let diccc:NSDictionary = (dicc["temperature_list"] as! NSArray).firstObject as! NSDictionary
            weakSelf.tempmodel = GYWTDRadarModel.deserialize(from: diccc)!
            weakSelf.radarCharData(array: weakSelf.tempmodel.stove_lists,dic: diccc)
            
        }
    }
    
    func radarCharData(array:NSArray,dic:NSDictionary) {
        scrollView.setZoomScale(1, animated: true)
        scrollView.contentSize = CGSize(width: APP.WIDTH * 2 * scrollView.zoomScale, height: APP.WIDTH * 3 * scrollView.zoomScale)
        scrollView.contentOffset = CGPoint(x: oricontentoffset.x * scrollView.zoomScale, y: oricontentoffset.y * scrollView.zoomScale)
        
        radarView.dataDic = dic as! [AnyHashable : Any]
        
        radarView.themColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        radarView.block = { [weak self] (value) in
            guard let weakSelf = self else {
                return
            }
            let dataModel = GYWTDRadarData.deserialize(from: weakSelf.tempmodel.stove_lists[value] as? NSDictionary)
            weakSelf.midshowview.label2.text = dataModel?.name
            weakSelf.midshowview.label3.text = String(format: "%.2f", (dataModel?.value)!)
        }
        
        radarView.block2 = { [weak self] (value) in
            guard let weakSelf = self else {
                return
            }
            let dataModel = GYWTDRadarData.deserialize(from: weakSelf.tempmodel.stove_lists[value] as? NSDictionary)
            weakSelf.midshowview.label2.text = dataModel?.name
            weakSelf.midshowview.label3.text = String(format: "%.2f", (dataModel?.value)!)
        }
        radarView.setNeedsDisplay()
//        spreadsheetView.reloadData()
//        spreadsheetView.snp.remakeConstraints { make in
//            make.top.equalTo(scrollView.snp.bottom).offset(20)
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.width.equalTo(APP.WIDTH - 20)
//            make.height.equalTo((dataArray.count + 1) * 39)
//            make.bottom.equalTo(-30)
//        }
    }
    
    func radarCharData(array:NSArray) {
        var dataEntries = [AASeriesElement]()
        var data = [Any]()
        var data2:NSMutableArray = []
        var chartmodelStr = [String]()
        
        //默认从正北开始0，所以要多加90
        let angle = Int(tempmodel.offsetAngle! + tempmodel.offsetAngle2! + 90) % 360
        let radius = self.view.frame.size.width / 2 - 25
        for i in 0..<4 {
            let angleInRadians = -CGFloat(angle + 90 * i).truncatingRemainder(dividingBy: 360)
            let x1 = radius * cos(angleInRadians*Double.pi/180)
            let y1 = radius * sin(angleInRadians*Double.pi/180)
            var label:UILabel = UILabel()
            if let label2 = bgView.viewWithTag(1000 + i) as? UILabel{
                label = label2
            }else{
                label = UILabel(frame: CGRect(x: radius + x1, y: radius - y1, width: 35, height: 20))
            }
            
            label.text = "\(90 * i)°"
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textAlignment = .center
            label.tag = 1000 + i
            bgView.addSubview(label)
            
            let view = SBRadarCharts()
            let  p = view.calcCircleCoordinate(withCenter: radarCharView.center, andWithAngle: CGFloat(angle + 90 * i), andWithRadius: radius - 5)
            label.center = p
        }
        bgView.bringSubviewToFront(namepickView)
        bgView.bringSubviewToFront(namepickView2)
        
        for _ in 0..<360  {
            chartmodelStr.append("")
        }
        for i in 0..<array.count {
            let dataModel = GYWTDRadarData.deserialize(from: (array[i] as? NSArray)![0] as? NSDictionary)
            var angle:Int64 = Int64((dataModel?.angle)!)
            if tempmodel.clockwise == 1 {
                print("当前为顺时针")
                //顺时针
                if angle > 360 {
                    angle = angle - 360
                }else if angle < 0 {
                    angle = angle + 360
                }
            }else{
                print("当前为逆时针")
                angle = 360 - angle
                if angle > 360 {
                    angle = angle - 360
                }else if angle < 0 {
                    angle = angle + 360
                }
            }
            data2.add([angle,dataModel?.value])
        }
        data.append([0,0.1])
        data.append([359,0])
        
        
        let gradientColor = AAGradientColor.linearGradient(
            direction: .toLeft,
            startColor: "#ADC6FF",
            endColor: "#ADC6FF"
        )
    
        let aa = AASeriesElement()
            .name("定位点")
            .data(data)
            .color(gradientColor)
            
        
        let aa2 = AASeriesElement()
            .name(nameStr)
            .data(data2 as! [Any])
            .color(gradientColor)
        
        dataEntries.append(aa)
        dataEntries.append(aa2)
        let chartmodel = AAChartModel()
            .chartType(.polygon)
            .polar(true)
            
            .dataLabelsEnabled(false)
            .xAxisVisible(true)
            .xAxisGridLineWidth(0.5)
            .yAxisVisible(true)
            .yAxisLabelsEnabled(false)
            .markerSymbol(.circle)
            .markerSymbolStyle(.borderBlank)
            .legendEnabled(false)
            .categories(chartmodelStr)
            .series(dataEntries)
            .zoomType(.xy)
        radarCharView.aa_drawChartWithChartModel(chartmodel)
    }
    
    @objc func groupBtnClick() {
        if dataArray.count == 0 {
            return
        }
        
        let vc = GYSelectGroupViewController()
        vc.dataArray = NSMutableArray(array: dataArray)
        vc.tempArray = NSMutableArray(array: datatempSectionArray)
        vc.titleLabel.text = "组别"
        vc.ClickBlock = { [weak self] array in
            guard let weakSelf = self else {
                return
            }
            GYHUD.showGif(view: weakSelf.view)
            weakSelf.datatempSectionArray = NSMutableArray(array: array)
            //拿回来的数组存在顺序错乱，是否排列以后再定
            weakSelf.requestnextdata(array: weakSelf.datatempSectionArray)
        }
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
    
    @objc func screenBtnClick() {
        namepickView.isHidden = false
    }
    
    @objc func screenBtn2Click() {
        namepickView2.isHidden = false
    }
    
    @objc func queryBtnClick() {
        if datatempSectionArray.count == 0 {
            GYHUD.show("请先选择组别")
            return
        }
        requestnextdata(array: datatempSectionArray)
    }
}

extension GYWTDRadarViewController:AAChartViewDelegate {
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
//        let labelarray = ["热流","出温","入温","温差","流量"]
//        let labelarray2 = ["reFlow","outTemp","inTemp","tempWc","flow"]
//        let dic:NSDictionary = dataArray[0] as! NSDictionary
//        let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: dic)!
        if clickEventMessage.name == "定位点" {
            midshowview.label2.text = "定位点"
            midshowview.label3.text = "0.00"
            return
        }
        
        let dataModel = GYWTDRadarData.deserialize(from: datatempSectionArray[clickEventMessage.index!] as? NSDictionary)
        midshowview.label2.text = dataModel?.name
        midshowview.label3.text = String(format: "%.2f", (dataModel?.value)!)
    }
}

extension GYWTDRadarViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == namepickView {
            return dataSectionArray.count
        }else{
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == namepickView {
            let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
            return (dic["name"] as! String)
        }else{
            
            return labelarray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        midshowview.label2.text = "组别"
        midshowview.label3.text = "0.00"
        if pickerView == namepickView {
            if dataSectionArray.count == 0 {
                return
            }
            let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
            screenBtn.setTitle((dic["name"] as! String), for: .normal)
            requestnextdata(array: [dataSectionArray[row]])
        }else{
            if datatempSectionArray.count == 0 {
                return
            }
            nameStr = labelarray[row]
            screenBtn2.setTitle(nameStr, for: .normal)
            radarCharData(array: datatempSectionArray)
        }
    }
}

extension GYWTDRadarViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return radarView
    }
     
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oricontentoffset = CGPointMake(scrollView.contentOffset.x / scrollView.zoomScale, scrollView.contentOffset.y / scrollView.zoomScale)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        scrollView.contentSize = CGSize(width: APP.WIDTH * 2 * scrollView.zoomScale, height: APP.WIDTH * 3 * scrollView.zoomScale)
        scrollView.contentOffset = CGPoint(x: oricontentoffset.x * scrollView.zoomScale, y: oricontentoffset.y * scrollView.zoomScale)
    }
}

extension GYWTDRadarViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        if menu == screenBtnMenu {
            return UInt(dataSectionArray.count)
        }else{
            return 5
        }
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 44
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        if menu == screenBtnMenu {
            let dic:NSDictionary = dataSectionArray[Int(index)] as! NSDictionary
            return (dic["name"] as! String)
        }else{
            
            return labelarray[Int(index)]
        }
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        midshowview.label2.text = "组别"
        midshowview.label3.text = "0.00"
        GYHUD.showGif(view: self.view)
        if menu == screenBtnMenu {
            if dataSectionArray.count == 0 {
                return
            }
            let dic:NSDictionary = dataSectionArray[Int(index)] as! NSDictionary
            requestdata2(array: [dataSectionArray[Int(index)]])
        }else{
            if datatempSectionArray.count == 0 {
                return
            }
            typeString = Int(index + 1)
            nameStr = labelarray[Int(index)]
            requestnextdata(array: datatempSectionArray)
        }
    }
    
}
