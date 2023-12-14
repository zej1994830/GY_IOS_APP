//
//  GYTRTRadarViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/23.
//

import UIKit
import AAInfographics

class GYTRTRadarViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var sectionStr:String = ""
    var dataArray:NSArray = []
    var tempmodel:GYRTRadarModel = GYRTRadarModel()
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 110, bottom: 0, right: -30)
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
        self.title = "雷达图"
        
        setupViews()
        addLayout()
        
        request()
    }
    
}

extension GYTRTRadarViewController {
    func setupViews() {
        self.view.addSubview(bgView)
        bgView.addSubview(screenLabel)
        bgView.addSubview(screenBtn)
        bgView.addSubview(barcharView)
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
        
        screenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(screenLabel)
            make.left.equalTo(screenLabel.snp.right)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        barcharView.snp.makeConstraints { make in
            make.top.equalTo(screenBtn.snp.bottom).offset(90)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func screenBtnClick() {
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
        screenBtn.setTitle(sectionStr, for: .normal)
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
            weakSelf.radarCharData(array: weakSelf.tempmodel.resultModel)
        }
    }
    
    func radarCharData(array:NSArray) {
        var dataEntries = [AASeriesElement]()
        var data = [Any]()
        var data2 = [Any]()
        var chartmodelStr = [String]()
        let angle = Int(tempmodel.offsetAngle! + tempmodel.offsetAngle2!) % 360
        for i in 0..<360  {
            if tempmodel.clockwise == 1 {
                if angle == 0 {
                    if i == angle {
                        chartmodelStr.append("0°")
                        continue
                    }
                }
                if angle > 0 {
                    if i + 1 == angle {
                        chartmodelStr.append("0°")
                        continue
                    }
                }else {
                    if i == angle + 360 {
                        chartmodelStr.append("0°")
                        continue
                    }
                }

                if angle + 90 > 0 {
                    if i == (angle + 90) % 360 {
                        chartmodelStr.append("90°")
                        continue
                    }

                    if angle + 90 == 360 && i == 360{
                        chartmodelStr.append("90°")
                        continue
                    }
                }else{
                    if i == (angle + 90 + 360) % 360 {
                        chartmodelStr.append("90°")
                        continue
                    }
                }

                if angle + 180 > 0 {
                    if i + 1 == (angle + 180) % 360{
                        chartmodelStr.append("180°")
                        continue
                    }
                    if angle + 180 == 360 && i + 1 == 360{
                        chartmodelStr.append("180°")
                        continue
                    }
                }else{
                    if i + 1 == (angle + 180 + 360) % 360 {
                        chartmodelStr.append("180°")
                        continue
                    }
                }

                if angle + 270 > 0 {
                    if i == (angle + 270) % 360{
                        chartmodelStr.append("270°")
                        continue
                    }
                    if angle + 270 == 360 && i + 1 == 360{
                        chartmodelStr.append("270°")
                        continue
                    }
                }else{
                    if i == (angle + 270 + 360) % 360 {
                        chartmodelStr.append("270°")
                        continue
                    }
                }
            }else{
                //逆时针
                if angle > 0 {
                    if i == 360 - angle {
                        chartmodelStr.append("0°")
                        continue
                    }
                }else {
                    if i == -angle {
                        chartmodelStr.append("0°")
                        continue
                    }
                }

                if angle + 90 > 0 {
                    if i == 360 - (angle + 90) {
                        chartmodelStr.append("90°")
                        continue
                    }
                }else{
                    if i == (-90 - angle) % 360 {
                        chartmodelStr.append("90°")
                        continue
                    }
                }

                if angle + 180 > 0 {
                    if i == 360 - (angle + 180) {
                        chartmodelStr.append("180°")
                        continue
                    }
                }else{
                    if i + 1 == (180 - angle) % 360 {
                        chartmodelStr.append("180°")
                        continue
                    }
                }
                //没完
                if angle + 270 > 0 {
                    if i == 360 - (angle + 270) {
                        chartmodelStr.append("270°")
                        continue
                    }
                }else{
                    if i == (270 - angle) % 360 {
                        chartmodelStr.append("270°")
                        continue
                    }
                }
            }
            chartmodelStr.append("")
        }
        for i in 0..<array.count {
            let dataModel = GYRTRadarData.deserialize(from: array[i] as? NSDictionary)
            var angle:Int = Int((dataModel?.insertion_angle)!)!
            if tempmodel.clockwise == 1 {
                print("当前为顺时针")
                //顺时针
                if angle > 360 {
                    angle = angle - 360
                }else if angle < 0 {
                    angle = angle + 360
                }
            }else{
                print("当前为逆时针")
                angle = 360 - angle
                if angle > 360 {
                    angle = angle - 360
                }else if angle < 0 {
                    angle = angle + 360
                }
            }
            data2.append([angle,Double((dataModel?.temperature)!)] as [Any])
        }

        data.append([359,0])
        data.append([0,0])

        let gradientColor = AAGradientColor.linearGradient(
            direction: .toLeft,
            startColor: "#ADC6FF",
            endColor: "#ADC6FF"
        )

        let aa = AASeriesElement()
            .name("原点")
            .data(data)
            .color(gradientColor)


        let aa2 = AASeriesElement()
            .data(data2)
        aa2.fillColor = "rgba(0, 0, 0, 0)"
        aa2.lineWidth = 0
        aa2.tooltip?.shared(true)
        
        dataEntries.append(aa)
        dataEntries.append(aa2)

        let chartmodel = AAChartModel()
            .chartType(.area)
            .polar(true)
            .dataLabelsEnabled(true)
            .xAxisVisible(true)
            .xAxisGridLineWidth(0.5)
            .yAxisVisible(true)
//            .yAxisLineWidth(1)
            .yAxisLabelsEnabled(false)
            .markerSymbol(.circle)
            .markerSymbolStyle(.borderBlank)
            .legendEnabled(false)
            .categories(chartmodelStr)
//            .margin(right: 30,left: 50)
            .series(dataEntries)
            .zoomType(.xy)
            
        barcharView.aa_drawChartWithChartModel(chartmodel)
        
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
        let dic:NSDictionary = dataSectionArray[row] as! NSDictionary
        screenBtn.setTitle((dic["name"] as! String), for: .normal)
        requestnextdata(array: [dataSectionArray[row]])

        pickerView.isHidden = true
    }
    
    open func aaChartView(_ aaChartView: AAChartView, clickEventMessage: AAClickEventMessageModel) {
        let dataModel = GYRTRadarData.deserialize(from: tempmodel.resultModel[clickEventMessage.index!] as? NSDictionary)
        let vc = GYTRTRadarDetailViewController()
        vc.model = dataModel!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
