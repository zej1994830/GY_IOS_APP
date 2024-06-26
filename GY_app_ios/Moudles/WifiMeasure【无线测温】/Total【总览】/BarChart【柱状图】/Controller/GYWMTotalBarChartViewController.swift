//
//  GYWMTotalBarChartViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/6/3.
//

import UIKit
import AAInfographics

class GYWMTotalBarChartViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSMutableArray = []
    var dataArray:NSArray = []{
        didSet{
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 170, bottom: 0, right: -30)
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
    
    private lazy var screenBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
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
    
    private lazy var bottomView:UIView = {
        let view = UIView()
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

extension GYWMTotalBarChartViewController {
    func setupViews() {
        self.title = "柱状图"
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtnMenu)
        self.view.addSubview(midView)
        midView.addSubview(midBgView)
        midView.addSubview(midtitleLabel)
        midView.addSubview(midshowview)
        midView.addSubview(barcharView)
        midView.addSubview(bottomView)
        
        self.view.addSubview(namepickView)
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
            make.bottom.equalTo(-19)
        }
        
        screenBtnMenu.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(200)
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
            make.width.equalTo(220)
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
}

extension GYWMTotalBarChartViewController {
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
        screenBtnMenu.title = sectionStr
        let params = ["device_db":GYDeviceData.default.device_db,"partId":partid,"type":1] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getcwsngrouplistdata, parameters: params) {[weak self] (result) in
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
        let data:NSMutableArray = []
        let categories:NSMutableArray = []
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                return
            }
            
            data.add(tempp["value"] ?? 0)
            categories.add(tempp["name"] ?? "")
        }
        
        let model = AAChartModel()
            .chartType(.column)
            .colorsTheme(["#EA173D"])
            .animationType(.easeOutCubic)
            .animationDuration(1200)
            .zoomType(.x)
            .series([
                AASeriesElement()
                    .name(sectionStr)
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


extension GYWMTotalBarChartViewController:UIPickerViewDelegate,UIPickerViewDataSource,AAChartViewDelegate {
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
        let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
        screenBtn.setTitle((dic["name"] as! String), for: .normal)
        requestnextdata(array: [dataSectionArray[row]])
        midshowview.label2.text = ""
        midshowview.label3.text = ""
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
        let dic:NSDictionary = dataArray[clickEventMessage.index!] as! NSDictionary
        midshowview.label2.text = dic["name"] as! String
        midshowview.label2.snp.remakeConstraints { make in
            make.left.equalTo(midshowview.label1.snp.right).offset(15)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
        midshowview.label3.text = String(dic["value"] as! Double)
    }

}

extension GYWMTotalBarChartViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(dataSectionArray.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 44
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        let dic:NSDictionary = dataSectionArray[Int(index)] as! NSDictionary
        return (dic["name"] as! String)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {

        if dataSectionArray.count == 0 {
            return
        }
        requestnextdata(array: [dataSectionArray[Int(index)]])
        midshowview.label2.text = ""
        midshowview.label3.text = ""
    }
    
}
