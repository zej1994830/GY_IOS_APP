//
//  GYWMGraphicBarChartViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/6/5.
//

import UIKit
import AAInfographics

class GYWMGraphicBarChartViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSMutableArray = []
    var nowrow:Int = 0
    var dataArray:NSArray = []{
        didSet {
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(barcharView)
            }
        }
    }
    var sectionStr:String = ""
    var nowindex:Int = 0
    
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
        btn.setTitle("一段", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: -30)
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 110, bottom: 0, right: -50)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 355 - APP.WIDTH, bottom: 0, right: 15)
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
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F5C105")
        view.label2.text = "组别"
        view.label3.text = "00.00"
        view.label3.snp.remakeConstraints { make in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(22.5)
            make.top.equalTo(view.label2.snp.bottom).offset(7.5)
        }
        return view
    }()
    
    private lazy var bottomView:UIView = {
        let view = UIView()
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
    
    private lazy var barcharView:AAChartView = {
        let view = AAChartView()
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        request()
    }

}

extension GYWMGraphicBarChartViewController {
    func setupViews() {
        self.title = "柱状图"
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtn)
        bgView.addSubview(timeLabel)
        bgView.addSubview(timeBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(midBgView)
        midView.addSubview(midtitleLabel)
        midView.addSubview(midshowview)
        midView.addSubview(barcharView)
        midView.addSubview(bottomView)
        
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
        timeBtn.setTitle(currentDateString, for: .normal)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        screenLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(21)
            make.width.equalTo(50)
        }
        
        screenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(140)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(screenLabel.snp.bottom).offset(36)
            make.height.equalTo(21)
            make.bottom.equalTo(-19)
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
            make.width.equalTo(80)
        }
        
        barcharView.snp.makeConstraints { make in
            make.top.equalTo(midBgView.snp.bottom).offset(25)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(barcharView.snp.bottom).offset(60)
            make.height.equalTo(36)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func screenBtnClick() {
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
                weakSelf.requestnextdata(array: [weakSelf.dataSectionArray[weakSelf.nowrow]])
            }
        }))
    }
    
}

extension GYWMGraphicBarChartViewController {
    func request() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":3] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswclist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["section_list"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            weakSelf.datatempSectionArray = NSMutableArray(array: weakSelf.dataSectionArray)
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
    }
    
    func requestnextdata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partid:Int32 = 0
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partid = dic["id"] as! Int32
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        screenBtn.setTitle(sectionStr, for: .normal)
        let params = ["end_time":currentDateString + ":00","device_db":GYDeviceData.default.device_db,"idString":partid,"type":1] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getwmchartdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            if weakSelf.dataArray.count > 0 {
                weakSelf.radarCharData(array: weakSelf.dataArray)
            }
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
            .chartType(.column)
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
        
        barcharView.aa_drawChartWithChartModel(model)
        
        
    }
    
    func drawindexview(array:[[NSDictionary]]) {
        for view in bottomView.subviews {
            view.removeFromSuperview()
        }
        
        let leftBtn:UIButton = UIButton()
        leftBtn.setImage(UIImage(named: "lk_leftvector"), for: .normal)
        leftBtn.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        
        let rightBtn:UIButton = UIButton()
        rightBtn.setImage(UIImage(named: "lk_rightvector"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
        
        let lineLable:UILabel = UILabel()
        lineLable.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#666666")
        
        bottomView.addSubview(leftBtn)
        bottomView.addSubview(rightBtn)
        bottomView.addSubview(lineLable)
        
        var buttonviewarray = [GYFSBarChartButton]()
        for i in 0..<array.count {
            let button = GYFSBarChartButton()
            if i == 0 {
                button.isSelected = true
            }
            button.tag = i + 100
            button.bottomlabel.text = "\(i + 1)"
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            bottomView.addSubview(button)
            buttonviewarray.append(button)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.left.equalTo(15)
            make.width.equalTo(14)
            make.height.equalTo(24)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.right.equalTo(-15)
            make.width.equalTo(14)
            make.height.equalTo(24)
        }
        
        lineLable.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.height.equalTo(1)
            make.top.equalTo(leftBtn)
        }
        
        buttonviewarray.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 20,leadSpacing: 40,tailSpacing: 40)
        buttonviewarray.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.width.equalTo(20)
            make.height.equalTo(36)
        }
        
    }
    
    @objc func buttonClick(_ button:GYFSBarChartButton) {
        // 将NSArray转换为Swift中的数组类型
        let swiftArray = dataArray as! [NSArray]
        // 按照十个一组重新分割数组
        let result = chunkArray(array: swiftArray as! [NSDictionary], chunkSize: 10)
        for i in 0..<result.count {
            let tempbutton:GYFSBarChartButton = self.view.viewWithTag(i + 100)! as! GYFSBarChartButton
            tempbutton.isSelected = false
            
        }
        button.isSelected = true
        nowindex = button.tag - 100
        radarCharData(array: result[nowindex] as NSArray)
    }
    
    // 定义一个函数来按照指定大小分割数组
    func chunkArray<T>(array: [T], chunkSize: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0..<Swift.min($0 + chunkSize, array.count)])
        }
    }

    @objc func leftButtonClick() {
        // 将NSArray转换为Swift中的数组类型
        let swiftArray = dataArray as! [NSArray]
        // 按照十个一组重新分割数组
        let result = chunkArray(array: swiftArray as! [NSDictionary], chunkSize: 10)
        for i in 0..<result.count {
            let tempbutton:GYFSBarChartButton = self.view.viewWithTag(i + 100)! as! GYFSBarChartButton
            if tempbutton.isSelected {
                if i != 0 {
                    tempbutton.isSelected = false
                    let temppbutton:GYFSBarChartButton = self.view.viewWithTag(i + 100 - 1)! as! GYFSBarChartButton
                    temppbutton.isSelected = true
                    nowindex = i - 1
                    radarCharData(array: result[i - 1] as NSArray)
                    break
                }
            }
        }
    }
    
    @objc func rightButtonClick() {
        // 将NSArray转换为Swift中的数组类型
        let swiftArray = dataArray as! [NSArray]
        // 按照十个一组重新分割数组
        let result = chunkArray(array: swiftArray as! [NSDictionary], chunkSize: 10)
        for i in 0..<result.count {
            let tempbutton:GYFSBarChartButton = self.view.viewWithTag(i + 100)! as! GYFSBarChartButton
            if tempbutton.isSelected {
                if i != result.count {
                    tempbutton.isSelected = false
                    let temppbutton:GYFSBarChartButton = self.view.viewWithTag(i + 100 + 1)! as! GYFSBarChartButton
                    temppbutton.isSelected = true
                    nowindex = i + 1
                    radarCharData(array: result[i + 1] as NSArray)
                    break
                }
            }
        }
    }
}

extension GYWMGraphicBarChartViewController:UIPickerViewDelegate,UIPickerViewDataSource,AAChartViewDelegate {
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
        nowrow = row
        let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
        screenBtn.setTitle((dic["name"] as! String), for: .normal)
        requestnextdata(array: [dataSectionArray[row]])

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
        
        midshowview.label2.text = clickEventMessage.category
        midshowview.label3.text = "\(clickEventMessage.y ?? 00)"
    }

}
