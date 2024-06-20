//
//  GYFSDataTimeViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/1.
//

import UIKit
import SpreadsheetView

class GYFSDataTimeViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSArray = []
    var dataArray:NSArray = []{
        didSet{
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(spreadsheetView)
            }
        }
    }
    var sectionStr:String = ""
    //数据分类（0：分钟，1：小时，2：日，3：月
    var rate:Int = 0
    //获取数据的类型（0:温差，1:入水温度，2:出水温度，3：流量，4:热流）
    var type:Int = 0
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var screenLabel:UILabel = {
        let label = UILabel()
        label.text = "筛选："
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间："
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: -25)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 5)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 120, bottom: 0, right: -50)
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
    
    private lazy var spreadsheetView:SpreadsheetView = {
        let view = SpreadsheetView()
        view.delegate = self
        view.dataSource = self
        view.gridStyle = .solid(width: 1, color: UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD"))
        view.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        view.bounces = false
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

extension GYFSDataTimeViewController {
    func setupViews() {
        self.title = "数据"
        
        let dateFormatter = DateFormatter()
        // 根据需要设置日期时间格式
        if rate == 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        }else if rate == 1 {
            dateFormatter.dateFormat = "yyyy-MM-dd HH"
        }else if rate == 2 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }else if rate == 3 {
            dateFormatter.dateFormat = "yyyy-MM"
        }
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
//        let startIndex = currentDateString.index(currentDateString.startIndex, offsetBy: 5)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
        
        //处理时间，必须ymdhms格式才可以
        if rate == 0 {
            currentDateString = currentDateString + ":00"
            currentLastHourDateString = currentLastHourDateString + ":00"
        }else if rate == 1 {
            currentDateString = currentDateString + ":00:00"
            currentLastHourDateString = currentLastHourDateString + ":00:00"
        }else if rate == 2 {
            currentDateString = currentDateString + " 00:00:00"
            currentLastHourDateString = currentLastHourDateString + " 00:00:00"
        }else if rate == 3 {
            currentDateString = currentDateString + "-01 00:00:00"
            currentLastHourDateString = currentLastHourDateString + "-01 00:00:00"
        }
        
        self.view.addSubview(headView)
        headView.addSubview(screenLabel)
        headView.addSubview(nameBtn)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        self.view.addSubview(midView)
        midView.addSubview(spreadsheetView)
        self.view.addSubview(namepickView)
    }
    
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
        }
        
        screenLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.width.equalTo(60)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.left.equalTo(screenLabel.snp.right)
            make.centerY.equalTo(screenLabel)
            make.height.equalTo(40)
            make.width.equalTo(140)
        }
        
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(screenLabel.snp.bottom).offset(40)
            make.left.equalTo(screenLabel)
            make.width.equalTo(60)
            make.bottom.equalTo(-22.5)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.left.equalTo(nameBtn)
            make.centerY.equalTo(timeLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
        }
        
        midView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(headView.snp.bottom).offset(5)
        }
        
        spreadsheetView.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.bottom.right.equalTo(0)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    @objc func nameBtnClick() {
        self.view.insertSubview(namepickView, aboveSubview: noDataView)
        namepickView.isHidden = false
    }
    
   
    
    @objc func timeBtnClick() {
        var timemodel:BRDatePickerMode = .YMDHM
        //数据分类（0：分钟，1：小时，2：日，3：月
        if rate == 0 {
            timemodel = .YMDHM
        }else if rate == 1 {
            timemodel = .YMDH
        }else if rate == 2 {
            timemodel = .YMD
        }else if rate == 3 {
            timemodel = .YM
        }
        
        BRDatePickerView.showDatePicker(with: timemodel, title: "选择时间", selectValue: nil ,isAutoSelect: false) { (date1,str) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: .init(block: {
                BRDatePickerView.showDatePicker(with: timemodel, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date2,str2) in
                    guard let weakSelf = self else{
                        return
                    }
                    if date1! > date2! {
                        GYHUD.show("开始时间不能大于结束时间")
                        return
                    }
//                    let startIndex = str2!.index(str2!.startIndex, offsetBy: 5)
                    weakSelf.currentDateString = str2!
                    weakSelf.currentLastHourDateString = str!
                    weakSelf.timeBtn.setTitle(weakSelf.currentLastHourDateString + " 至 " + weakSelf.currentDateString, for: .normal)
                    GYHUD.showGif(view: weakSelf.view)
                    //处理时间，必须ymdhms格式才可以
                    if weakSelf.rate == 0 {
                        weakSelf.currentDateString = weakSelf.currentDateString + ":00"
                        weakSelf.currentLastHourDateString = weakSelf.currentLastHourDateString + ":00"
                    }else if weakSelf.rate == 1 {
                        weakSelf.currentDateString = weakSelf.currentDateString + ":00:00"
                        weakSelf.currentLastHourDateString = weakSelf.currentLastHourDateString + ":00:00"
                    }else if weakSelf.rate == 2 {
                        weakSelf.currentDateString = weakSelf.currentDateString + " 00:00:00"
                        weakSelf.currentLastHourDateString = weakSelf.currentLastHourDateString + " 00:00:00"
                    }else if weakSelf.rate == 3 {
                        weakSelf.currentDateString = weakSelf.currentDateString + "-01 00:00:00"
                        weakSelf.currentLastHourDateString = weakSelf.currentLastHourDateString + "-01 00:00:00"
                    }
                    weakSelf.requestnextdata(array: weakSelf.datatempSectionArray )
                }
            }))
            
        }
    }
    
    func requestdata(){
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":1] as [String:Any]
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
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partidString = String(format: "%d", dic["id"] as! Int64)
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        nameBtn.setTitle(sectionStr, for: .normal)
        
        let params = ["device_db":GYDeviceData.default.device_db,"partId":partidString,"start_time":currentLastHourDateString,"end_time":currentDateString,"rate":rate] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getlkfmtimedata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["temperature_list"] as! NSArray
//            let diccc:NSDictionary = weakSelf.dataArray.firstObject as! NSDictionary
//            let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
            
            
            weakSelf.spreadsheetView.reloadData()
        }
    }
}

extension GYFSDataTimeViewController:UIPickerViewDelegate,UIPickerViewDataSource {
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
        if pickerView == namepickView {
            pickerView.isHidden = true
            if dataSectionArray.count == 0 {
                return
            }
            let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
            nameBtn.setTitle((dic["name"] as! String), for: .normal)
            datatempSectionArray = [dataSectionArray[row]]
            requestnextdata(array: [dataSectionArray[row]])
        }
    }
    
}

extension GYFSDataTimeViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        return 36
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 38
        }else if column == 1 {
            return 156
        }else{
            return 108
        }
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        //列
        if dataArray.count > 0 {
            let dic:NSDictionary = dataArray.firstObject as! NSDictionary
            return dic.allKeys.count + 1
        }
        
        return 1
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        //行
        return dataArray.count + 1
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        //列
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        //行
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
        cell.label.textAlignment = .center
        cell.label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cell.color = .white
        
        
        if indexPath.row == 0 {
            cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
            cell.label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            if indexPath.column == 0{
                cell.label.text = ""
            }else if indexPath.column == 1 {
                cell.label.text = "时间"
                cell.label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            }else{
                let dic:NSDictionary = dataArray.firstObject as! NSDictionary
                let dicc = NSMutableDictionary(dictionary: dic)
                if dicc["时间"] != nil {
                    dicc.removeObject(forKey: "时间")
                }
                cell.label.text = (dicc.allKeys[indexPath.column - 2] as! String)
            }
            return cell
        }
        if indexPath.column == 0 {
            //序号
            cell.label.text = "\(indexPath.row)"
            return cell
        }else if indexPath.column == 1 {
            //时间
            let dic:NSDictionary = dataArray[indexPath.row - 1] as! NSDictionary
            cell.label.text = (dic["时间"] as! String)
            return cell
        }else{
            //值
            let dic:NSDictionary = dataArray[indexPath.row - 1] as! NSDictionary
            let dicc = NSMutableDictionary(dictionary: dic)
            if dicc["时间"] != nil {
                dicc.removeObject(forKey: "时间")
            }
            cell.label.text = String(format: "%.3f", (dicc.allValues[indexPath.column - 2] as? Double ?? 0.00))
        }
        return cell
    }
    
}
