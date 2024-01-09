//
//  GYFSTotalTrendViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/14.
//

import UIKit
import AAInfographics

class GYFSTotalTrendViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var model:GYFSDataModel = GYFSDataModel()
    var dataarray:NSArray = []
    var timeArray:[String] = ["5分钟","15分钟","30分钟","1小时","2小时","8小时","16小时","1天","7天","15天","1个月"]
    var rate:Int32 = 0
    var selectIndex:IndexPath = IndexPath(row: -1, section: 0)
    //MARK: - 头视图
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
    
    private lazy var pinlvLabel:UILabel = {
        let label = UILabel()
        label.text = "频率："
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
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 355 - APP.WIDTH, bottom: 0, right: 15)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(pinlvBtnClick), for: .touchUpInside)
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
    
    private lazy var wenduView:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#BC7DFC")
        view.label2.text = "温度"
        view.label3.text = "0.00"
        return view
    }()
    
    private lazy var lineView2:AAChartView = {
        let view = AAChartView()
        view.delegate = self as AAChartViewDelegate
        return view
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = rellySizeForiPhoneWidth(60, 27.5)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 6.5)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWTDTrendCell.classForCoder(), forCellWithReuseIdentifier: GYWTDTrendCell.indentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    
    private lazy var timepickView:UIPickerView = {
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
//MARK: -

extension GYFSTotalTrendViewController {
    
    func setupViews() {
        self.title = "趋势"
        
        self.view.addSubview(headView)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(pinlvLabel)
        headView.addSubview(pinlvBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(bgView)
        midView.addSubview(midtimeLabel)
        midView.addSubview(wenduView)
        midView.addSubview(lineView2)
        midView.addSubview(collectionV)
        self.view.addSubview(timepickView)
        
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
        headView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(-15)
            make.left.equalTo(timeLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        pinlvLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp_bottomMargin).offset(41)
            make.left.height.equalTo(timeLabel)
        }
        
        pinlvBtn.snp.makeConstraints { make in
            make.centerY.equalTo(pinlvLabel)
            make.left.equalTo(timeBtn)
            make.height.equalTo(40)
            make.width.equalTo(78)
            make.bottom.equalTo(-13.5)
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
       
        wenduView.snp.makeConstraints { make in
            make.top.equalTo(midtimeLabel.snp.bottom).offset(11)
            make.width.equalTo(45)
            make.left.equalTo(26)
        }

        lineView2.snp.makeConstraints { make in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.bottom.equalTo(-115)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(lineView2.snp.bottom).offset(10)
        }
        
        timepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func request() {
        GYHUD.showGif(view: self.view)
        let params = ["start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00","rate":rate,"device_db":GYDeviceData.default.device_db,"stoveid_list":model.id!] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getlktrend, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            
            GYHUD.hideHudForView(weakSelf.view)
            
            let dic:NSDictionary = result as! NSDictionary
            if dic["stauts"] != nil{
                GYHUD.show("请求错误")
                return
            }
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let array:NSArray = dicc["stove_list"] as! NSArray
            
            if array.count == 0 {
                GYHUD.show("此时间段没有数据，请重新选择时间段！")
            }else{
                let diccc:NSDictionary = array.firstObject as! NSDictionary
                let array2:NSArray = diccc["data"] as! NSArray
                if array2.count == 0 {
                    GYHUD.show("此时间段没有数据，请重新选择时间段！")
                }else{
                    weakSelf.dataarray = array2
                    weakSelf.linedata2(strname: diccc["stove_name"] as! String)
                }
            }
        }
    }
    
    func linedata2(strname:String) {
        var dataEntries = [AASeriesElement]()
        var categories = [String]()
        var data = [Any]()
        for i in 0..<dataarray.count {
            let dic = dataarray[i] as! NSDictionary
            categories.append(dic["dt"]! as! String)
            data.append(dic["value"] ?? 0)
        }
        let aa = AASeriesElement()
            .name(strname)
            .data(data)
        dataEntries.append(aa)
        
        
        
        let chartmodel = AAChartModel()
            .chartType(.line)
            .colorsTheme(["#0182F9"])
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
        lineView2.aa_drawChartWithChartModel(chartmodel)
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
                    weakSelf.request()
                }
            }))
            
        }
    }
    
    @objc func pinlvBtnClick() {
        timepickView.isHidden = false
    }
}

extension GYFSTotalTrendViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "分钟"
        }else{
            return "小时"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
//            return "分钟"
            rate = 0
            pinlvBtn.setTitle("分钟", for: .normal)
        }else{
//            return "小时"
            rate = 1
            pinlvBtn.setTitle("小时", for: .normal)
        }
        
        pickerView.isHidden = true
        request()
    }
}

//MARK: 时间段选择
extension GYFSTotalTrendViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWTDTrendCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDTrendCell.indentifier, for: indexPath) as? GYWTDTrendCell
        
        if cell == nil {
            cell = GYWTDTrendCell()
        }
        cell?.labelStr = timeArray[indexPath.row]
        if indexPath == selectIndex {
            cell?.btn.setTitleColor(.white, for: .normal)
            cell?.btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        }else{
            cell?.btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
            cell?.btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        let calendar = Calendar.current
        //        ["5分钟","15分钟","30分钟","1小时","2小时","8小时","16小时","1天","7天","15天","1个月"]
        if indexPath.row == 0 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .minute, value: -5, to: currentDate)!)
        }else if indexPath.row == 1 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .minute, value: -15, to: currentDate)!)
        }else if indexPath.row == 2 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .minute, value: -30, to: currentDate)!)
        }else if indexPath.row == 3 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
        }else if indexPath.row == 4 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -2, to: currentDate)!)
        }else if indexPath.row == 5 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -8, to: currentDate)!)
        }else if indexPath.row == 6 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -16, to: currentDate)!)
        }else if indexPath.row == 7 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .day, value: -1, to: currentDate)!)
        }else if indexPath.row == 8 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .day, value: -7, to: currentDate)!)
        }else if indexPath.row == 9 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .day, value: -15, to: currentDate)!)
        }else if indexPath.row == 10 {
            currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .month, value: -1, to: currentDate)!)
        }
//        let startIndex = currentDateString.index(currentDateString.startIndex, offsetBy: 5)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
        request()
        collectionView.reloadData()
    }
}

extension GYFSTotalTrendViewController:AAChartViewDelegate {
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
        let dic = dataarray[clickEventMessage.index!] as! NSDictionary
        midtimeLabel.text = String(format: "时间：%@", dic["dt"] as! String)
        wenduView.label3.text =  String(format: "%.2f", dic["value"] as! Double)
    }
}
