//
//  GYTHCurveViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/4.
//

import UIKit
import AAInfographics

class GYTHCurveViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSArray = []
    var sectionStr:String = ""
    var groupStr:String = ""
    var dataArray:NSArray = []
    var datagroupArray:NSArray = []
    var datatempgroupArray:NSArray = []
    var indexrow:Int = 0
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var model:GYWTDDataModel = GYWTDDataModel()
    var timeArray:[String] = ["5分钟","15分钟","30分钟","1小时","2小时","8小时","16小时","1天","7天","15天","1个月"]
    var rate:Int32 = 0
    var selectIndex:IndexPath = IndexPath(row: -1, section: 0)
    var maincolors = ["#EA173D","#A75FF0","#02BE8B","#A75FF0","#F9861B"]
    var selectcolors = ["#BB1231","#02986F","#02986F","#864CC0","#C76B16"]
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = "标高："
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 110, bottom: 0, right: -30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = .left
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
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 325 - APP.WIDTH, bottom: 0, right: 10)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("TE1241、TE1242", for: .normal)
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
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EA173D")
        view.label2.text = "TE1241"
        view.label3.text = "0.07"
        return view
    }()
    
    private lazy var showGroupView2:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#A75FF0")
        view.label2.text = "TE1242"
        view.label3.text = "0.02"
        return view
    }()
    
    private lazy var showGroupView3:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F5C105")
        view.label2.text = "C1-3"
        view.label3.text = "41.03"
        view.isHidden = true
        return view
    }()
    
    private lazy var showGroupView4:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#0182F9")
        view.label2.text = "C1-4"
        view.label3.text = "27.98"
        view.isHidden = true
        return view
    }()
    
    private lazy var showGroupView5:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#0182F9")
        view.label2.text = "C1-4"
        view.label3.text = "27.98"
        view.isHidden = true
        return view
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

extension GYTHCurveViewController {
    func setupViews() {
        self.title = "历史曲线"
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
        midView.addSubview(showGroupView)
        midView.addSubview(showGroupView2)
        midView.addSubview(showGroupView3)
        midView.addSubview(showGroupView4)
        midView.addSubview(showGroupView5)
        midView.addSubview(lineView)
        midView.addSubview(collectionV)
        self.view.addSubview(namepickView)
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
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(130)
            make.left.equalTo(nameLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        pinlvLabel.snp.makeConstraints { make in
            make.left.equalTo(nameBtn.snp.right).offset(24)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        pinlvBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(70)
            make.left.equalTo(pinlvLabel.snp_rightMargin).offset(10)
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
        
        let arr = [showGroupView,showGroupView2,showGroupView3,showGroupView4,showGroupView5]
//        arr.snp.distributeViewsAlong(axisType:.horizontal,fixedSpacing: 24,leadSpacing: 24,tailSpacing: 24)
        arr.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 55,leadSpacing: 24,tailSpacing: 24)
        arr.snp.makeConstraints { make in
            make.top.equalTo(midtimeLabel.snp.bottom).offset(11)
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

extension GYTHCurveViewController {
    func requestdata(){
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdobiaogao, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataSectionArray = dic["data"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            weakSelf.datatempSectionArray = [weakSelf.dataSectionArray.firstObject as Any]
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
        
    }
    
    func requestnextdata(array:NSArray){
        var partid:Int64 = 0
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partid = dic["id"] as! Int64

        sectionStr = String(format: "%@", dic["name"] as! String)
        nameBtn.setTitle(sectionStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"id":partid] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdobiaogaoduanwei, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.datagroupArray = dicc["data"] as! NSArray
            if weakSelf.datagroupArray.count > 0 {
                weakSelf.datatempgroupArray = [weakSelf.datagroupArray.firstObject as Any]
                weakSelf.requestlastdata(array:[weakSelf.datagroupArray.firstObject as Any])
            }
        }
    }
    
    func requestlastdata(array:NSArray) {
        var partidString:String = ""
        groupStr = ""
        for temp in array {
            let dic:NSDictionary = temp as! NSDictionary
            if partidString.count == 0 {
                //筛选状态
                partidString = dic["stove_id"] as! String
                //段名
                groupStr = dic["stove_name"] as! String
            }else{
                partidString = String(format: "%@,%@", partidString,(dic["stove_id"] as! String))
                groupStr = String(format: "%@,%@", groupStr,(dic["stove_name"] as! String))
            }
            
        }

        groupBtn.setTitle(groupStr, for: .normal)
        let params = ["device_db":GYDeviceData.default.device_db,"stoveid_list":partidString,"state":rate,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00"] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdohistorychartdata, parameters: params) {[weak self] (result) in
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
        let categories:NSMutableArray = []
        var dataEntries = [AASeriesElement]()
        
        for temp in array {
            guard let tempp = temp as? NSDictionary else {
                return
            }
            guard let tempdataarray = tempp["data"] as? NSArray else {
                return
            }
            var data = [Any]()
            for i in 0..<tempdataarray.count {
                let dic = tempdataarray[i] as! NSDictionary
                data.append(Double(dic["value"] as! String) as Any )
                categories.add(dic["dt"]!)
            }
            let aa = AASeriesElement()
                .name(tempp["stove_name"]! as! String)
                .data(data)
            dataEntries.append(aa)
            
        }
        
        let model = AAChartModel()
            .chartType(.line)
            .colorsTheme(maincolors)
            .animationType(.easeOutCubic)
            .animationDuration(1200)
            .zoomType(.x)
            .series(dataEntries)
            .categories(categories as! [String])
            .tooltipEnabled(true)
        
        lineView.aa_drawChartWithChartModel(model)
        
    }
    
    @objc func nameBtnClick() {
        namepickView.isHidden = false
    }
    
    @objc func pinlvBtnClick() {
        timepickView.isHidden = false
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
                    GYHUD.showGif(view: weakSelf.view)
                    weakSelf.requestlastdata(array: weakSelf.datatempgroupArray)
                }
            }))
            
        }
    }
    
    @objc func groupBtnClick() {
        let vc = GYWTDTrendItemsGroupViewController()
        vc.type = 3
        vc.dataArray = NSMutableArray(array: datagroupArray)
        vc.tempArray = NSMutableArray(array: datatempgroupArray)
        vc.titleLabel.text = "组别"
        vc.ClickBlock = { [weak self] array in
            guard let weakSelf = self else {
                return
            }
            weakSelf.datatempgroupArray = NSMutableArray(array: array)
            //拿回来的数组存在顺序错乱，是否排列以后再定
            weakSelf.requestlastdata(array: weakSelf.datatempgroupArray)
        }
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
}

extension GYTHCurveViewController:UIPickerViewDelegate,UIPickerViewDataSource {
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

extension GYTHCurveViewController:UICollectionViewDelegate,UICollectionViewDataSource,AAChartViewDelegate {
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
        GYHUD.showGif(view: self.view)
        requestlastdata(array: datatempgroupArray)
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
        for i in 0..<dataArray.count {
            let dic = dataArray[i] as! NSDictionary
            let temparray:NSArray = dic["data"] as! NSArray
            let tempdic = temparray[clickEventMessage.index!] as! NSDictionary
            if i == 0 {
                showGroupView.label2.text = String(format: "%@", dic["stove_name"] as! String)
                showGroupView.label3.text = String(format: "%.2f", tempdic["value"] as! Double)
            }
            if i == 1 {
                showGroupView2.label2.text = String(format: "%@", dic["stove_name"] as! String)
                showGroupView2.label3.text = String(format: "%.2f", tempdic["value"] as! Double)
            }
            if i == 2 {
                showGroupView3.label2.text = String(format: "%@", dic["stove_name"] as! String)
                showGroupView3.label3.text = String(format: "%.2f", tempdic["value"] as! Double)
            }
            if i == 3 {
                showGroupView4.label2.text = String(format: "%@", dic["stove_name"] as! String)
                showGroupView4.label3.text = String(format: "%.2f", tempdic["value"] as! Double)
            }
            if i == 4 {
                showGroupView5.label2.text = String(format: "%@", dic["stove_name"] as! String)
                showGroupView5.label3.text = String(format: "%.2f", tempdic["value"] as! Double)
            }
        }
        
    }
}

