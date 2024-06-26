//
//  GYTRTRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/23.
//

import UIKit
import AAInfographics
import SpreadsheetView

@objc class GYTRTRadarViewController: GYViewController {
    var oricontentoffset:CGPoint = CGPoint(x: 0, y: 0)
    var dataSectionArray:NSArray = []
    var sectionStr:String = ""
    var dataArray:NSArray = []{
        didSet{
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(spreadsheetView)
            }
        }
    }
    var tempmodel:GYRTRadarModel = GYRTRadarModel()
    
    private lazy var bgView:UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        return view
    }()
    
    private lazy var screenLabel:UILabel = {
        let label = UILabel()
        label.text = "标高："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var screenBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("标高10.602米", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 130, bottom: 0, right: -30)
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
    
    private lazy var radarView:SBRadarCharts = {
        let view = SBRadarCharts()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "雷达图"
        
        setupViews()
        addLayout()
        
        request()
        
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        oricontentoffset = scrollView.contentOffset
    }
    
}

extension GYTRTRadarViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return radarView
    }
     
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        oricontentoffset = CGPointMake(scrollView.contentOffset.x / scrollView.zoomScale, scrollView.contentOffset.y / scrollView.zoomScale)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        scrollView.contentSize = CGSize(width: APP.WIDTH * 2 * scrollView.zoomScale, height: APP.WIDTH * 3 * scrollView.zoomScale)
        scrollView.contentOffset = CGPoint(x: oricontentoffset.x * scrollView.zoomScale, y: oricontentoffset.y * scrollView.zoomScale)
//        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        
//        radarView.snp.remakeConstraints { make in
//            make.height.equalTo(APP.WIDTH - 60)
//            make.width.equalTo(APP.WIDTH - 60)
//            make.centerX.equalTo(scrollView.contentSize.width / 2)
//            make.centerY.equalTo(scrollView.contentSize.height / 2)
//        }
//        scrollView.contentOffset = CGPoint(x: radarView.center.x - (APP.WIDTH / 2), y: radarView.center.y - (scrollView.frame.width / 2))
//
        print("scrollView.contentOffset === %ld",scrollView.contentOffset)
        print("oricontentoffset -----%ld",oricontentoffset)
    }
    
    
}

extension GYTRTRadarViewController {
    func setupViews() {
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtnMenu)
        bgView.addSubview(scrollView)
        scrollView.addSubview(radarView)
        bgView.addSubview(spreadsheetView)
        bgView.addSubview(namepickView)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.bottom.equalTo(0)
        }
        
        screenLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.height.equalTo(21)
            make.width.equalTo(50)
        }
        
        screenBtnMenu.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(screenBtnMenu.snp.bottom)
            make.height.equalTo(APP.WIDTH * 1.4)
        }
        
        radarView.snp.makeConstraints { make in
            make.height.equalTo(APP.WIDTH - 60)
            make.width.equalTo(APP.WIDTH - 60)
            make.centerX.equalTo(scrollView.contentSize.width / 2)
            make.centerY.equalTo(scrollView.contentSize.height / 2)
        }
        
        spreadsheetView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.width.equalTo(APP.WIDTH - 30)
            make.height.equalTo(100)
            make.bottom.equalTo(-30)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func screenBtnClick() {
        bgView.bringSubviewToFront(namepickView)
        namepickView.isHidden = false
    }
    
    func request() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdobiaogao, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataSectionArray = dic["data"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
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
        let params = ["device_db":GYDeviceData.default.device_db,"id":partid] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getrdorealdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let diccc:NSDictionary = dicc["data"] as! NSDictionary
            weakSelf.dataArray = diccc["resultModel"] as! NSArray
            weakSelf.tempmodel = GYRTRadarModel.deserialize(from: diccc)!
            weakSelf.radarCharData(array: weakSelf.tempmodel.resultModel,dic:diccc)
        }
    }
    
    func radarCharData(array:NSArray,dic:NSDictionary) {
        radarView.dataDic = dic as! [AnyHashable : Any]
        
        radarView.themColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
//        radarView.currentSelf = self
        radarView.block = { [weak self] (value) in
            guard let weakSelf = self else {
                return
            }
            let dataModel = GYRTRadarData.deserialize(from: weakSelf.tempmodel.resultModel[value] as? NSDictionary)
            let vc = GYTRTRadarDetailViewController()
            vc.model = dataModel!
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
        radarView.block2 = { [weak self] (value) in
            guard let weakSelf = self else {
                return
            }
            let dataModel = GYRTRadarData.deserialize(from: weakSelf.tempmodel.resultModel[value] as? NSDictionary)
            let vc = GYTRTRadarDetailViewController()
            vc.model = dataModel!
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        radarView.setNeedsDisplay()
        spreadsheetView.reloadData()
        spreadsheetView.snp.remakeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(APP.WIDTH - 20)
            make.height.equalTo((dataArray.count + 1) * 39)
            make.bottom.equalTo(-30)
        }
        
        return

    }
}

extension GYTRTRadarViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        return 37
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if column == 0 {
            return 38
        }else if column == 1 {
            return (APP.WIDTH - 20 - 45 - 64 * 3)
        }else{
            return 64
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
                cell.label.text = "热电偶"
            }else if indexPath.column == 2 {
                cell.label.text = "角度"
            }else if indexPath.column == 3 {
                cell.label.text = "插深"
            }else if indexPath.column == 4 {
                cell.label.text = "温度"
            }
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
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left // 设置文本的对齐方式为左对齐
                
                let attrString = NSMutableAttributedString(string: "  " + model.name!)
                cell.label.numberOfLines = 0
                let attr: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(red: 0.1, green: 0.45, blue: 0.91, alpha: 1), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor(red: 0.1, green: 0.45, blue: 0.91, alpha: 1),.paragraphStyle:paragraphStyle]
                attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
                cell.label.attributedText = attrString
            }else if indexPath.column == 2 {
                //
                cell.label.text = model.insertion_angle
            }else if indexPath.column == 3 {
                //
                cell.label.text = model.insertion_height
            }else if indexPath.column == 4 {
                //
                if let floatValue = Float(model.temperature!) {
                    cell.label.text = "\(Int(floatValue.rounded()))"
                }
                
            }
        }
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.column == 1 {
            if indexPath.row  != 0 {
                let dataModel = GYRTRadarData.deserialize(from: tempmodel.resultModel[indexPath.row - 1] as? NSDictionary)
                let vc = GYTRTRadarDetailViewController()
                vc.model = dataModel!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension GYTRTRadarViewController:UIPickerViewDelegate,UIPickerViewDataSource,AAChartViewDelegate {
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
        scrollView.zoomScale = 1.0
        scrollView.contentSize = CGSize(width: APP.WIDTH * 2 * scrollView.zoomScale, height: APP.WIDTH * 3 * scrollView.zoomScale)
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
        screenBtn.setTitle((dic["name"] as! String), for: .normal)
        requestnextdata(array: [dataSectionArray[row]])
    }
   
}

extension GYTRTRadarViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
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
        scrollView.zoomScale = 1.0
        scrollView.contentSize = CGSize(width: APP.WIDTH * 2 * scrollView.zoomScale, height: APP.WIDTH * 3 * scrollView.zoomScale)
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 4, y: (scrollView.contentSize.height / 4))
        requestnextdata(array: [dataSectionArray[Int(index)]])
    }
    
}
