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
                make.center.size.equalTo(scrollView)
            }
        }
    }
    var dataGroupArray:NSArray = []
    var datatempGroupArray:NSMutableArray = []
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var oricontentoffset:CGPoint = CGPoint(x: 0, y: 0)

    
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
    
    private lazy var nameBtnMenu:LMJDropdownMenu = {
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
    
    private lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_rili"), for: .normal)
        btn.setTitle("2023-04-16 14:43 至 2023-04-18 14:43", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 100, bottom: 0, right: -50)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 100, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
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
    
    private lazy var radarView:GYWMRadarView = {
        let view = GYWMRadarView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var lineView:AAChartView = {
        let view = AAChartView()
        view.contentWidth = APP.WIDTH * 2
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
        requestdata()
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        oricontentoffset = scrollView.contentOffset
    }

}

extension GYWMGraphicRadarViewController {
    func setupViews() {
        self.title = "雷达图"
        self.view.addSubview(headView)
        headView.addSubview(nameLabel)
        headView.addSubview(nameBtnMenu)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(groupLabel)
        headView.addSubview(groupBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(bgView)
        midView.addSubview(midtimeLabel)
        midView.addSubview(showGroupView)
        midView.addSubview(scrollView)
        scrollView.addSubview(radarView)
        self.view.addSubview(namepickView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH" // 根据需要设置日期时间格式
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
        
        nameBtnMenu.snp.makeConstraints { make in
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
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(bgView.snp.bottom)
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
        nameBtnMenu.title = sectionStr
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
        
        let params = ["device_db":GYDeviceData.default.device_db,"end_time":currentDateString + ":00:00","idString":stoveidString,"type":2] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getwmchartdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            weakSelf.radarCharData(array: weakSelf.dataArray,dic: dic)
            
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
            let dic:NSDictionary = weakSelf.dataArray[value] as! NSDictionary
            weakSelf.showGroupView.label2.text = (dic["name"] as! String)
            weakSelf.showGroupView.label3.text = String(format: "%.3f", dic["value"] as! Double)
        }
        
        radarView.block2 = { [weak self] (value) in
            guard let weakSelf = self else {
                return
            }
            let dic:NSDictionary = weakSelf.dataArray[value] as! NSDictionary
            weakSelf.showGroupView.label2.text = (dic["name"] as! String)
            weakSelf.showGroupView.label3.text = String(format: "%.3f", dic["value"] as! Double)
        }
        radarView.setNeedsDisplay()
    }
    
    @objc func nameBtnClick() {
        self.view.insertSubview(namepickView, aboveSubview: noDataView)
        namepickView.isHidden = false
    }
    
    @objc func timeBtnClick() {
        BRDatePickerView.showDatePicker(with: .YMDH, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date2,str2) in
            guard let weakSelf = self else{
                return
            }
            weakSelf.timeBtn.setTitle(str2!, for: .normal)
            weakSelf.currentDateString = str2!
            weakSelf.requestdata()
        }
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
        
    }
}

extension GYWMGraphicRadarViewController:UIScrollViewDelegate {
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

extension GYWMGraphicRadarViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
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
        requestnextdata(array: [dataSectionArray[Int(index)]])
    }
    
}
