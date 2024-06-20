//
//  GYWMGraphicTrendViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/6/4.
//

import UIKit
import AAInfographics

class GYWMGraphicTrendViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSArray = []
    var sectionStr:String = ""
    var dataArray:NSArray = []
    var dataGroupArray:NSArray = []{
        didSet{
            noDataView.isHidden = dataGroupArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(lineView)
            }
        }
    }
    var datatempGroupArray:NSMutableArray = []
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var middataarray:NSMutableArray = []
    var randomColorarray:NSMutableArray = []
    var timeArray:[String] = ["5分钟","15分钟","30分钟","1小时","2小时","8小时","16小时","1天","7天","15天","1个月"]
    var rate:Int32 = 0
    var selectIndex:IndexPath = IndexPath(row: -1, section: 0)
    var maincolors = ["#EA173D","#02BE8B","#02BE8B","#A75FF0","#F9861B"]
    var selectcolors = ["#BB1231","#02986F","#02986F","#864CC0","#C76B16"]
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = "场所："
        return label
    }()
    
    private lazy var pinlvLabel:UILabel = {
        let label = UILabel()
        label.text = "频率："
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 135, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(pinlvBtnClick), for: .touchUpInside)
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
        label.text = "时间："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var midCollectionV = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 147, height: 80)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 6.5)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWMMidCell.classForCoder(), forCellWithReuseIdentifier: GYWMMidCell.indentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var lineView:AAChartView = {
        let view = AAChartView()
        view.isScrollEnabled = false
        view.delegate = self
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
        requestdata()
    }
    

}

extension GYWMGraphicTrendViewController {
    func setupViews() {
        self.title = "趋势"
        self.view.addSubview(headView)
        headView.addSubview(nameLabel)
        headView.addSubview(nameBtn)
        headView.addSubview(pinlvLabel)
        headView.addSubview(pinlvBtn)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(groupLabel)
        headView.addSubview(groupBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(bgView)
        midView.addSubview(midtimeLabel)
        midView.addSubview(midCollectionV)
        midView.addSubview(lineView)
        midView.addSubview(collectionV)
        self.view.addSubview(namepickView)
        self.view.addSubview(timepickView)
        
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
            make.width.equalTo(155)
            make.left.equalTo(nameLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        pinlvBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(70)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
        
        pinlvLabel.snp.makeConstraints { make in
            make.right.equalTo(pinlvBtn.snp.left)
            make.top.equalTo(21)
            make.height.equalTo(21)
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
            make.height.equalTo(110)
        }
        
        midtimeLabel.snp.makeConstraints { make in
            make.left.equalTo(15.5)
            make.top.equalTo(20)
        }
        
        midCollectionV.snp.makeConstraints { make in
            make.left.equalTo(midtimeLabel)
            make.right.equalTo(bgView)
            make.top.equalTo(midtimeLabel.snp.bottom).offset(10)
            make.bottom.equalTo(bgView).offset(-10)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.bottom.equalTo(-115)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
}

extension GYWMGraphicTrendViewController {
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
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partid = dic["id"] as! Int32
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        nameBtn.setTitle(sectionStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"id":partid] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getBFLsTagList, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataGroupArray = dic["data"] as! NSArray
            weakSelf.requestlastdata(array: [weakSelf.dataGroupArray.firstObject as Any])
        }
    }
    
    func requestlastdata(array:NSArray) {
        datatempGroupArray = NSMutableArray(array: array)
        var namestr:String = ""
        var stoveidString:String = ""
        midtimeLabel.text = "时间："
        middataarray.removeAllObjects()
        midCollectionV.reloadData()
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                groupBtn.setTitle(namestr, for: .normal)
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
        let params = ["device_db":GYDeviceData.default.device_db,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00","state":rate,"stoveid_list":stoveidString,"type":1] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.gettrendchartdata, parameters: params) {[weak self] (result) in
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
        var dataEntries = [AASeriesElement]()
        var categories = [String]()
//        randomColorarray.removeAllObjects()
        for i in 0..<dataArray.count {
            let dic = dataArray[i] as! NSDictionary
//            randomColorarray.add(randomHexColor())
            var data = [Any]()
            let array = dic["data"] as! NSArray
            if array.count > 0 {
                noDataView.isHidden = true
                for j in 0..<array.count {
                    let dicc = array[j] as! NSDictionary
                    if let value = Double(dicc["value"] as! String) {
                        data.append(value)
                    }
                    if i == 0 {
                        categories.append(dicc["dt"]! as! String)
                    }
                }
                let aa = AASeriesElement()
                    .name(dic["stove_name"] as! String)
                    .data(data)
                dataEntries.append(aa)
            }else {
                GYHUD.show("此时间段没有数据，请重新选择时间段！")
                noDataView.isHidden = false
                noDataView.snp.remakeConstraints { make in
                    make.center.size.equalTo(lineView)
                }
            }
        }
        
        
        let chartmodel = AAChartModel()
            .chartType(.line)
            .colorsTheme(["#0182F9","#BC7DFC","#12B48D","#F5C105","#FF6E66"])
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
    
    @objc func nameBtnClick() {
        self.view.insertSubview(namepickView, aboveSubview: noDataView)
        namepickView.isHidden = false
        timepickView.isHidden = true
    }
    
    @objc func pinlvBtnClick() {
        self.view.insertSubview(timepickView, aboveSubview: noDataView)
        timepickView.isHidden = false
        namepickView.isHidden = true
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
                    weakSelf.selectIndex = IndexPath(row: -1, section: 0)
                    weakSelf.collectionV.reloadData()
                    weakSelf.requestlastdata(array: weakSelf.datatempGroupArray)
                }
            }))
            
        }
    }
    
    @objc func groupBtnClick() {
        if dataGroupArray.count == 0 {
            GYHUD.show("当前数据没有组别")
            return
        }
        
        let vc = GYWTDTrendItemsGroupViewController()
        vc.dataArray = NSMutableArray(array: dataGroupArray)
        vc.tempArray = NSMutableArray(array: datatempGroupArray)
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

extension GYWMGraphicTrendViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == namepickView {
            return dataSectionArray.count
        }else{
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == namepickView {
            let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
            return (dic["name"] as! String)
        }else{
            if row == 0 {
                return "分钟"
            }else{
                return "小时"
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        
        if pickerView == namepickView {
            if dataSectionArray.count == 0 {
                return
            }
            requestnextdata(array: [dataSectionArray[row]])
        }else{
            if row == 0 {
                rate = 0
                pinlvBtn.setTitle("分钟", for: .normal)
            }else{
                rate = 1
                pinlvBtn.setTitle("小时", for: .normal)
            }
            requestdata()
        }
    }
}

extension GYWMGraphicTrendViewController:UICollectionViewDelegate,UICollectionViewDataSource,AAChartViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionV {
            return timeArray.count
        }else{
//            return randomColorarray.count
            return middataarray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionV {
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
        }else {
            var cell:GYWMMidCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWMMidCell.indentifier, for: indexPath) as? GYWMMidCell
            
            if cell == nil {
                cell = GYWMMidCell()
            }
//            cell?.colorStr = randomColorarray[indexPath.row] as! String
            cell?.colorStr = ["#0182F9","#BC7DFC","#12B48D","#F5C105","#FF6E66"][indexPath.row]
            cell?.valuedic = middataarray[indexPath.row] as! NSDictionary
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == midCollectionV {
            return
        }
        
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
        requestdata()
        collectionView.reloadData()
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
        middataarray.removeAllObjects()
        for i in 0..<dataArray.count {
            let dic = dataArray[i] as! NSDictionary
            let array = dic["data"] as! NSArray
            let dicc = array[clickEventMessage.index!] as! NSDictionary
            middataarray.add(["stove_name":dic["stove_name"],"value":dicc["value"]])
            midtimeLabel.text = String(format: "时间：%@", dicc["dt"] as! String)
        }
        midCollectionV.reloadData()
    }
}

