//
//  GYETDataResultViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/12.
//

import UIKit
import SpreadsheetView

class GYETDataResultViewController: GYViewController {
    var dataArray:NSArray = []{
        didSet{
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(spreadsheetView)
            }
        }
    }
    var strArray:[String] = []
    var dataResultArray:NSMutableArray = []
    var stove_id:Int32 = 0
    var dataStr:String = ""
    //MARK: - 头视图
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "轴截面："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var platformBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("三层平台", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: -20)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(platformBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var platformBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        view.title = "设备地址"
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
    
    private lazy var spreadsheetView:SpreadsheetView = {
        let view = SpreadsheetView()
        view.delegate = self
        view.dataSource = self
        view.gridStyle = .solid(width: 1, color: UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD"))
        view.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        view.register(ETResultCell.self, forCellWithReuseIdentifier: String(describing: ETResultCell.self))
        view.register(ETSecResultCell.self, forCellWithReuseIdentifier: String(describing: ETSecResultCell.self))
        view.bounces = false
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
        // Do any additional setup after loading the view.
    }
    

}

extension GYETDataResultViewController {
    func setupViews() {
        self.title = "数据结果"
        self.view.addSubview(headView)
        headView.addSubview(titleLabel)
        headView.addSubview(platformBtnMenu)
        self.view.addSubview(midView)
        midView.addSubview(spreadsheetView)
        self.view.addSubview(namepickView)
    }
    
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.height.equalTo(21)
            make.bottom.equalTo(-21)
        }
        
        platformBtnMenu.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        midView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(0)
        }
        
        spreadsheetView.snp.makeConstraints { make in
            make.top.equalTo(11.5)
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.bottom.equalTo(-40)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func platformBtnClick() {
        self.view.insertSubview(namepickView, aboveSubview: noDataView)
        namepickView.isHidden = false
    }
    
    func requestdata() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhdirectionorlevellist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["data"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            let diccc:NSDictionary = weakSelf.dataArray.firstObject as! NSDictionary
            weakSelf.platformBtnMenu.title = "\(diccc["stove_name"] ?? "")"
            weakSelf.stove_id = diccc["stove_id"] as! Int32
            weakSelf.requestnextdata()
        }
    }
    
    func requestnextdata() {
        let params = ["device_db":GYDeviceData.default.device_db,"stove_id":stove_id] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhdirectiondataresult, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let array:NSArray = dicc["data"] as! NSArray
            let diccc:NSDictionary = array.firstObject as! NSDictionary
            weakSelf.dataStr = diccc["data"] as! String
            weakSelf.reloaddata()
        }
    }
    
    func reloaddata() {
        let index = dataStr.index(dataStr.startIndex, offsetBy: 171) // 获取第10位的索引
        let endIndex = dataStr.index(index, offsetBy: dataStr.count - 172 - 43, limitedBy: dataStr.endIndex) ?? dataStr.endIndex // 获取结束索引
        let substring = dataStr[index..<endIndex] // 切片获取子字符串
        strArray = substring.components(separatedBy: "\r\n       ")
        dataResultArray.removeAllObjects()
        for str in strArray {
            dataResultArray.add(str.split(separator: " ").map(String.init))
        }
        spreadsheetView.reloadData()
    }
}

extension GYETDataResultViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        if column == 0 {
            return 62
        }
        return 36
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 38
        }
        return 82
    }
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        
        return dataResultArray.count > 0 ? [CellRange(from: (0,1), to: (0,2)),CellRange(from: (0,3), to: (0,4))] : []
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        //列
         
        return dataResultArray.count > 0 ? 7 : 0
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        //行
        return dataResultArray.count + 1
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        //列
        return dataResultArray.count > 0 ? 1 : 0
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        //行
        return dataResultArray.count > 0 ? 1 : 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if indexPath.row == 0{
            // 1 3
            if indexPath.column == 1{
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ETResultCell.self), for: indexPath) as! ETResultCell
                cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
                cell.label.text = "最大边界"
                cell.label2.text = "Q4"
                cell.label3.text = "G4"
                return cell
            }
            
            if indexPath.column == 3{
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ETResultCell.self), for: indexPath) as! ETResultCell
                cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
                cell.label.text = "当前渣线"
                cell.label2.text = "Q5"
                cell.label3.text = "G6"
                return cell
            }
            
            if indexPath.column == 5 {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ETSecResultCell.self), for: indexPath) as! ETSecResultCell
                cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
                cell.label.text = "渣厚"
                cell.label2.text = "ZHAN"
                return cell
            }
            
            if indexPath.column == 6 {
                let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ETSecResultCell.self), for: indexPath) as! ETSecResultCell
                cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
                cell.label.text = "内衬厚度"
                cell.label2.text = "LinH"
                return cell
            }
        }
        
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
        cell.label.textAlignment = .center
        cell.label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cell.color = .white

        if indexPath.row == 0 {
            cell.color = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
            cell.label.text = ""
        }
        if indexPath.column == 0 && indexPath.row > 0 {
            cell.label.text = "\(indexPath.row)"
        }
        if indexPath.column != 0 && indexPath.row > 0 {
            let array:NSArray = dataResultArray[indexPath.row - 1] as! NSArray
            if indexPath.column < array.count {
                cell.label.text = (array[indexPath.column] as! String)
            }else {
                cell.label.text = ""
            }
            
        }
        
        return cell
    }
    
}


extension GYETDataResultViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dic:NSDictionary = dataArray[row] as! NSDictionary
        
        return (dic["stove_name"] as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        if dataArray.count == 0 {
            return
        }
        let dic:NSDictionary = dataArray[row] as! NSDictionary
        platformBtn.setTitle("\(dic["stove_name"] ?? "")", for: .normal)
        stove_id = dic["stove_id"] as! Int32
        requestnextdata()
    }
    
}

extension GYETDataResultViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
    func numberOfOptions(in menu: LMJDropdownMenu) -> UInt {
        return UInt(dataArray.count)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, heightForOptionAt index: UInt) -> CGFloat {
        return 44
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, titleForOptionAt index: UInt) -> String {
        let dic:NSDictionary = dataArray[Int(index)] as! NSDictionary
        return (dic["stove_name"] as! String)
    }
    
    func dropdownMenu(_ menu: LMJDropdownMenu, didSelectOptionAt index: UInt, optionTitle title: String) {

        if dataArray.count == 0 {
            return
        }
        let dic:NSDictionary = dataArray[Int(index)] as! NSDictionary
        stove_id = dic["stove_id"] as! Int32
        requestnextdata()
    }
    
}
