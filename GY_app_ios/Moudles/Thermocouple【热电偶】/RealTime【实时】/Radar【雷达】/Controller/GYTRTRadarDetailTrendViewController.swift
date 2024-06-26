//
//  GYTRTRadarDetailTrendViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/29.
//

import UIKit
import AAInfographics

class GYTRTRadarDetailTrendViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var dataArray:NSArray = []
    var model:GYRTRadarData = GYRTRadarData() {
        didSet{
            elevationBtn.setTitle("标高" + model.elevation! + "米", for: .normal)
        }
    }
    var rate:Int = 0
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var elevationLabel:UILabel = {
        let label = UILabel()
        label.text = "标高："
        return label
    }()
    
    private lazy var elevationBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("一段", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
//        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
//        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -30)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.contentHorizontalAlignment = .left
//        btn.addTarget(self, action: #selector(screenBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var pinlvLabel:UILabel = {
        let label = UILabel()
        label.text = "频率："
        return label
    }()
    
    private lazy var pinlvBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("分钟", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -25)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(pinlvBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var pinlvBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        view.title = "分钟"
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
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间："
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 115, bottom: 0, right: -40)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EA173D")
        view.label2.text = ""
        view.label3.text = "00.00"
        view.label3.snp.remakeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22.5)
            make.top.equalTo(view.label2.snp.bottom).offset(7.5)
        }
        return view
    }()
    
    private lazy var midshowview2:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#A75FF0")
        view.label2.text = ""
        view.label3.text = "00.00"
        view.label3.snp.remakeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22.5)
            make.top.equalTo(view.label2.snp.bottom).offset(7.5)
        }
        view.isHidden = true
        return view
    }()
    
    private lazy var lineView:AAChartView = {
        let view = AAChartView()
        view.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        request()
    }

}

extension GYTRTRadarDetailTrendViewController {
    func setupViews() {
        self.title = "历史曲线"
        self.view.addSubview(bgView)
        bgView.addSubview(elevationLabel)
        bgView.addSubview(elevationBtn)
        bgView.addSubview(pinlvLabel)
        bgView.addSubview(pinlvBtnMenu)
        bgView.addSubview(timeLabel)
        bgView.addSubview(timeBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(midBgView)
        midView.addSubview(midtitleLabel)
        midView.addSubview(midshowview)
        midView.addSubview(midshowview2)
        midView.addSubview(lineView)
        
        self.view.addSubview(namepickView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
//        let dateFormatter2 = DateFormatter()
//        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
//        let startIndex = currentDateString.index(currentDateString.startIndex, offsetBy: 5)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        elevationLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(21)
            make.width.equalTo(60)
        }
        
        elevationBtn.snp.makeConstraints { make in
            make.centerY.equalTo(elevationLabel)
            make.left.equalTo(elevationLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        pinlvLabel.snp.makeConstraints { make in
            make.centerY.equalTo(elevationLabel)
            make.height.equalTo(21)
            make.right.equalTo(pinlvBtnMenu.snp.left)
        }
        
        pinlvBtnMenu.snp.makeConstraints { make in
            make.centerY.equalTo(elevationLabel)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(elevationLabel.snp.bottom).offset(36)
            make.height.equalTo(21)
            make.bottom.equalTo(-19)
            make.width.equalTo(60)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(-15)
            make.left.equalTo(timeLabel.snp.right)
            make.height.equalTo(40)
        }
        
        midView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(bgView.snp.bottom).offset(5)
        }
            
        midBgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(15)
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
            make.width.equalTo(200)
        }
        
        midshowview2.snp.makeConstraints { make in
            make.left.equalTo(midshowview.snp.right).offset(15)
            make.bottom.equalTo(midBgView).offset(-7)
            make.top.equalTo(midtitleLabel.snp.bottom).offset(11)
            make.width.equalTo(80)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(midBgView.snp.bottom).offset(25)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH)
        }
        
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func pinlvBtnClick() {
        namepickView.isHidden = false
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
//                    let startIndex = str2!.index(str2!.startIndex, offsetBy: 5)
                    weakSelf.timeBtn.setTitle(str! + " 至 " + str2!, for: .normal)
                    weakSelf.currentDateString = str2!
                    weakSelf.currentLastHourDateString = str!
                    weakSelf.request()
                }
            }))
            
        }
    }
}

extension GYTRTRadarDetailTrendViewController {
    func request() {
        midshowview.label2.text = ""
        midshowview.label3.text = ""
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00","rate":rate,"stove_id":Int32(model.id!) as Any] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdorealhistorychartdata, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            weakSelf.linedata()
            GYHUD.hideHudForView(weakSelf.view)
        }
    }
    
    func linedata() {
        var dataEntries = [AASeriesElement]()
        var categories = [String]()
        
        let dic:NSDictionary = dataArray.firstObject as! NSDictionary
        let array:NSArray = dic["data"] as! NSArray
        var data = [Any]()
        for i in 0..<array.count {
            let dic = array[i] as! NSDictionary
            let valuestr:String = dic["value"] as! String
            data.append(Double(valuestr))
            categories.append(dic["time"]! as! String)
        }
        
        let aa = AASeriesElement()
            .name(dic["stove_name"]! as! String)
            .data(data)
        dataEntries.append(aa)
        
        let chartmodel = AAChartModel()
            .chartType(.line)
            .stacking(.normal)
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
            .scrollablePlotArea(AAScrollablePlotArea()
                .minWidth(3000)
                .scrollPositionX(1))
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
        let dic:NSDictionary = dataArray.firstObject as! NSDictionary
        let array:NSArray = dic["data"] as! NSArray
        let tempdic = array[clickEventMessage.index!] as! NSDictionary
        midshowview.label2.text = (tempdic["time"] as! String)
        midshowview.label3.text = (tempdic["value"]! as! String)
        
    }
}

extension GYTRTRadarDetailTrendViewController:UIPickerViewDelegate,UIPickerViewDataSource,AAChartViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ["分钟","小时"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pinlvBtn.setTitle(["分钟","小时"][row], for: .normal)
        rate = row
        request()
        pickerView.isHidden = true
    }
}

extension GYTRTRadarDetailTrendViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return 2
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 44
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        ["分钟","小时"][Int(index)]
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {
        rate = Int(index)
        request()
    }
    
}
