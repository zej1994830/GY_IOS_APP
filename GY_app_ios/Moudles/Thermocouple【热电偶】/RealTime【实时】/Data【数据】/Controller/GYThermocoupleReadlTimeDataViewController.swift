//
//  GYThermocoupleReadlTimeDataViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/4.
//

import UIKit
import SpreadsheetView

class GYThermocoupleReadlTimeDataViewController: GYViewController {
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
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var screenLabel:UILabel = {
        let label = UILabel()
        label.text = "标高："
        return label
    }()
    
    private lazy var nameBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 110, bottom: 0, right: -25)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 5)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nameBtnMenu:LMJDropdownMenu = {
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
    
    private lazy var spreadsheetView:SpreadsheetView = {
        let view = SpreadsheetView()
        view.delegate = self
        view.dataSource = self
        view.gridStyle = .solid(width: 1, color: UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD"))
        view.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
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
    }
}

extension GYThermocoupleReadlTimeDataViewController {
    func setupViews() {
        self.title = "数据"
        
      
        self.view.addSubview(headView)
        headView.addSubview(screenLabel)
        headView.addSubview(nameBtnMenu)
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
            make.bottom.equalTo(-22.5)
        }
        
        nameBtnMenu.snp.makeConstraints { make in
            make.left.equalTo(screenLabel.snp.right)
            make.centerY.equalTo(screenLabel)
            make.height.equalTo(40)
            make.width.equalTo(130)
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
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        sectionStr = ""
        let dic:NSDictionary = array.firstObject as! NSDictionary
        partidString = String(format: "%d", dic["id"] as! Int64)
        //段名
        sectionStr = String(format: "%@", dic["name"] as! String)
        nameBtnMenu.title = sectionStr

        let params = ["device_db":GYDeviceData.default.device_db,"id":partidString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdorealdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let diccc:NSDictionary = dicc["data"] as! NSDictionary
            weakSelf.dataArray = diccc["resultModel"] as! NSArray
//            let diccc:NSDictionary = weakSelf.dataArray.firstObject as! NSDictionary
//            let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
            
            
            weakSelf.spreadsheetView.reloadData()
        }
    }
}

extension GYThermocoupleReadlTimeDataViewController:UIPickerViewDelegate,UIPickerViewDataSource {
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

extension GYThermocoupleReadlTimeDataViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        return 36
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 38
        }else if column == 1 {
            return 81
        }else if column == 2 {
            return 130
        }else{
            return 91
        }
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        //列
        if dataArray.count > 0 {
            return 5
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
                cell.label.text = "标高"
            }else if indexPath.column == 2 {
                cell.label.text = "标签名称"
            }else if indexPath.column == 3 {
                cell.label.text = "插入角度"
            }else if indexPath.column == 4 {
                cell.label.text = "插入深度"
            }
//            GYRTRadarData
            return cell
        }
        if indexPath.column == 0 {
            //序号
            cell.label.text = "\(indexPath.row)"
            return cell
        }else {
            let dic:NSDictionary = dataArray[indexPath.row - 1] as! NSDictionary
            let model:GYRTRadarData = GYRTRadarData.deserialize(from: dic)!
            if indexPath.column == 1 {
                //
                cell.label.text = model.elevation
            }else if indexPath.column == 2 {
                //
                cell.label.text = model.name
            }else if indexPath.column == 3 {
                //
                cell.label.text = model.insertion_angle
            }else if indexPath.column == 4 {
                //
                cell.label.text = model.insertion_height
            }
        }
        return cell
    }
    
}

extension GYThermocoupleReadlTimeDataViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
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
        datatempSectionArray = [dataSectionArray[Int(index)]]
        requestnextdata(array: [dataSectionArray[Int(index)]])
    }
    
}
