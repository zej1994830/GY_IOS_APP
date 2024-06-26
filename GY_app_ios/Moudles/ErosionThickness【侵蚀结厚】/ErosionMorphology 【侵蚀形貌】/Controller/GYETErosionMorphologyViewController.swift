//
//  GYETErosionMorphologyViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/8.
//

import UIKit

class GYETErosionMorphologyViewController: GYViewController {
    var sectionArray:NSArray = [[["ic_qinshijiehou","侵蚀结厚"],["ic_shujujieguo","数据结果"],["ic_qushi","趋势"],["ic_lishixingmao","历史形貌"]]]
//    [[["ic_wenduchang","温度场"],["ic_qinshijiehou","侵蚀结厚"],["ic_shujujieguo","数据结果"],["ic_litimoxing","立体模型"],["ic_qushi","趋势"],["ic_lishixingmao","历史形貌"]]]
    var currentDateString:String = ""
    var dataArray:NSArray = []
    var histroydataArray:NSArray = []
    var stove_id:Int32 = 0
    var imagedatadic:NSDictionary = [:]
    var morphology_type:Int = 1
    var section_type:Int = 0
    var index = IndexPath(row: 0, column: 0)
    var timer = Timer()
    var inttimecount:Int = 0
    
    private lazy var bgView:UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.bounces = false
        return view
    }()
    
    //MARK: - 头视图
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var typeLabel:UILabel = {
        let label = UILabel()
        label.text = "显示形式："
        return label
    }()
    
    private lazy var modelBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 模型", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(modelBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var xingmaoBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 形貌", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(xingmaoBtnClick(_:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var sectionLabel:UILabel = {
        let label = UILabel()
        label.text = "显示截面："
        return label
    }()
    
    private lazy var zhoujiemianBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 轴截面", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(zhoujiemianBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var hengjiemianBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 横截面", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(hengjiemianBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sectionorientationLabel:UILabel = {
        let label = UILabel()
        label.text = "截面方位："
        return label
    }()
    
    private lazy var frontBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("前界面-方位3", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 130, bottom: 0, right: -30)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(frontBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var behindBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("后界面-方位28", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 130, bottom: 0, right: -30)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(behindBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var frontBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        view.title = "前界面-方位3"
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
    
    private lazy var behindBtnMenu:LMJDropdownMenu = {
        let view = LMJDropdownMenu()
        view.delegate = self
        view.dataSource = self
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2").cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        
        view.title = "后界面-方位28"
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
    
    private lazy var frontpickView:UIPickerView = {//废弃
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
    
    private lazy var behindpickView:UIPickerView = {//没废弃！！！
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
    
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: APP.WIDTH / 4, height: APP.WIDTH / 4)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GYETErosionMorphologyCell.classForCoder(), forCellWithReuseIdentifier: GYETErosionMorphologyCell.indentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.layer.cornerRadius = 2.5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var  midtitleLabel:UILabel = {
        let label = UILabel()
        label.text = "轴截面（1方位）"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var midsecLabel:UILabel = {
        let label = UILabel()
        label.text = "计算时间：2023-12-26 12:34"
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#666666")
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var autoBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select2"), for: .selected)
        btn.setTitle(" 自动巡检", for: .normal)
        btn.setTitleColor(UIColor.UIColorFromHexvalue(color_vaule: "#666666"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(autoBtnClick(_:)), for: .touchUpInside)
        btn.tag = 100
        return btn
    }()
    
    private lazy var circularimageV:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var scatterimageV:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var histogramimageV:UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
    
        request()
        request2()
        
    }

}

extension GYETErosionMorphologyViewController {
    func setupViews() {
        self.title = "侵蚀形貌"
        self.view.addSubview(bgView)
        bgView.addSubview(headView)
        headView.addSubview(typeLabel)
        headView.addSubview(modelBtn)
        headView.addSubview(xingmaoBtn)
        headView.addSubview(sectionLabel)
        headView.addSubview(zhoujiemianBtn)
        headView.addSubview(hengjiemianBtn)
        headView.addSubview(sectionorientationLabel)
        headView.addSubview(frontBtnMenu)
        headView.addSubview(behindBtnMenu)
        
        bgView.addSubview(midView)
        midView.addSubview(collectionV)
        midView.addSubview(iconLabel)
        midView.addSubview(midtitleLabel)
        midView.addSubview(midsecLabel)
        midView.addSubview(autoBtn)
        midView.addSubview(circularimageV)
        midView.addSubview(scatterimageV)
        midView.addSubview(histogramimageV)
        
        self.view.addSubview(frontpickView)
        self.view.addSubview(behindpickView)
    }
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(topHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        headView.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.right.left.equalTo(0)
            make.width.equalTo(APP.WIDTH)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(17)
            make.height.equalTo(21)
        }
        
        modelBtn.snp.makeConstraints { make in
            make.left.equalTo(typeLabel.snp.right).offset(15)
            make.centerY.equalTo(typeLabel)
            make.height.equalTo(20)
        }
        
        xingmaoBtn.snp.makeConstraints { make in
            make.left.equalTo(modelBtn.snp.right).offset(60)
            make.centerY.equalTo(typeLabel)
            make.height.equalTo(20)
        }
        
        sectionLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel)
            make.top.equalTo(typeLabel.snp.bottom).offset(21)
            make.height.equalTo(21)
        }
        
        zhoujiemianBtn.snp.makeConstraints { make in
            make.left.equalTo(modelBtn)
            make.centerY.equalTo(sectionLabel)
            make.height.equalTo(20)
        }
        
        hengjiemianBtn.snp.makeConstraints { make in
            make.left.equalTo(xingmaoBtn)
            make.centerY.equalTo(sectionLabel)
            make.height.equalTo(20)
        }
        
        sectionorientationLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel)
            make.top.equalTo(sectionLabel.snp.bottom).offset(21)
            make.height.equalTo(21)
        }
        
        frontBtnMenu.snp.makeConstraints { make in
            make.left.equalTo(modelBtn)
            make.top.equalTo(sectionorientationLabel)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
        
        behindBtnMenu.snp.makeConstraints { make in
            make.left.equalTo(frontBtnMenu)
            make.top.equalTo(frontBtnMenu.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.bottom.equalTo(-10)
        }
        
        midView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }

        collectionV.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH / 4)
        }

        iconLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(collectionV.snp.bottom).offset(10)
            make.width.equalTo(5)
            make.height.equalTo(16)
        }

        midtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconLabel)
            make.left.equalTo(iconLabel.snp.right).offset(10)
            make.height.equalTo(30)
        }

        midsecLabel.snp.makeConstraints { make in
            make.left.equalTo(midtitleLabel)
            make.top.equalTo(midtitleLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }

        autoBtn.snp.makeConstraints { make in
            make.left.equalTo(midtitleLabel)
            make.height.equalTo(21)
            make.width.equalTo(90)
            make.top.equalTo(midsecLabel.snp.bottom).offset(10)
        }

        circularimageV.snp.makeConstraints { make in
            make.top.equalTo(autoBtn.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(APP.WIDTH / 4 * 3)
        }

        scatterimageV.snp.makeConstraints { make in
            make.top.equalTo(circularimageV.snp.bottom).offset(10)
            make.left.right.equalTo(0)
        }

        histogramimageV.snp.makeConstraints { make in
            make.top.equalTo(scatterimageV.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        frontpickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        behindpickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }

    @objc func modelBtnClick(_ button:UIButton){
        
    }
    
    @objc func xingmaoBtnClick(_ button:UIButton){
        
    }
    
    @objc func zhoujiemianBtnClick(_ button:UIButton){
        if !button.isSelected {
            button.isSelected = true
            hengjiemianBtn.isSelected = false
            section_type = 0
            inttimecount = 0
            request2()
        }
    }
    
    @objc func hengjiemianBtnClick(_ button:UIButton){
        if !button.isSelected {
            button.isSelected = true
            zhoujiemianBtn.isSelected = false
            section_type = 1
            inttimecount = 0
            request2()
        }
    }
    
    @objc func frontBtnClick(){
        frontpickView.isHidden = false
        
    }
    
    @objc func behindBtnClick(_ button:UIButton){
        frontpickView.isHidden = false
    }
    
    @objc func autoBtnClick(_ button:UIButton){
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [self] timer in
                // 这里编写需要执行的自动刷新操作
                inttimecount += 1
                let dd = inttimecount % dataArray.count
                let dic:NSDictionary = dataArray[dd] as! NSDictionary
                frontBtn.setTitle("前界面-\(dic["stove_name"] ?? "")", for: .normal)
                behindBtn.setTitle("后界面-\(dic["stove_name"] ?? "")", for: .normal)
                midtitleLabel.text = "炉缸轴截面侵蚀形貌（\(dic["stove_name"] ?? "")）"
                stove_id = dic["stove_id"] as! Int32
                request3()
            }
        }else{
            timer.invalidate()
        }
        
    }
    
}

extension GYETErosionMorphologyViewController {
    func request() {
        let params = ["device_db":GYDeviceData.default.device_db] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhhistorytimenode, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.histroydataArray = dicc["data"] as! NSArray
            weakSelf.behindpickView.reloadAllComponents()
        }
    }
    
    func request2() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"type":section_type] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhdirectionorlevellist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["data"] as! NSArray
            weakSelf.frontpickView.reloadAllComponents()
            let diccc:NSDictionary = weakSelf.dataArray.firstObject as! NSDictionary
            weakSelf.frontBtnMenu.title = "前界面-\(diccc["stove_name"] ?? "")"
            weakSelf.behindBtnMenu.title = "后界面-\(diccc["stove_name"] ?? "")"
            weakSelf.midtitleLabel.text = "炉缸轴截面侵蚀形貌（\(diccc["stove_name"] ?? "")）"
            if let stove_id = diccc["stove_id"] as? Int32 {
                weakSelf.stove_id = stove_id
            }else{
                weakSelf.stove_id = Int32(diccc["stove_id"] as! String)!
            }
            
            
            weakSelf.collectionView(weakSelf.collectionV, didSelectItemAt: weakSelf.index)
        }
    }
    
    func request3() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"stove_id":stove_id,"option_list":"1,3","morphology_type":morphology_type,"section_type":section_type,"end_time":currentDateString + ":00"] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getqsjhortempdata, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            let array:NSArray = dicc["data"] as! NSArray
            weakSelf.imagedatadic = array.firstObject as! NSDictionary
            weakSelf.midsecLabel.text = "计算时间：\(weakSelf.imagedatadic["date"] ?? "")"
            weakSelf.updateImageV()
        }
    }
    
    func updateImageV() {
        let cirstr:String = imagedatadic["circularImg"] as? String ?? ""
        let scastr:String = imagedatadic["scatterImg"] as? String ?? ""
        let hisstr:String = imagedatadic["histogramImg"] as? String ?? ""
        circularimageV.image = UIImage(data: Data(base64Encoded: cirstr)!)
        scatterimageV.image = UIImage(data: Data(base64Encoded: scastr)!)
        histogramimageV.image = UIImage(data: Data(base64Encoded: hisstr)!)
    }
}


extension GYETErosionMorphologyViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYETErosionMorphologyCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYETErosionMorphologyCell.indentifier, for: indexPath) as? GYETErosionMorphologyCell
        
        if cell == nil {
            cell = GYETErosionMorphologyCell()
        }
        cell?.dataArray = (sectionArray[indexPath.section] as! NSArray)[indexPath.row] as! NSArray
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: index) {
            cell.backgroundColor = .white
        }
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor(red: 26/255.0, green: 115/255.0, blue: 232/255.0, alpha: 0.15)
        }
        if indexPath.row == 0 {
            morphology_type = 1 //以前的温度场是0 侵蚀结厚是1 现在取消了温度场
            index = indexPath
            request3()
        }else if indexPath.row == 1 {
            let vc = GYETDataResultViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = GYETTrendViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3 {
//            let vc = GYETStereoscopicMorphologyViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            if histroydataArray.count == 0 {
                GYHUD.show("目前没有历史数据")
                return
            }
            behindpickView.isHidden = false
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .white
        }
    }
}

extension GYETErosionMorphologyViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == frontpickView {
            return dataArray.count
        }else {
            return histroydataArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == frontpickView {
            let dic:NSDictionary = dataArray[row] as! NSDictionary
            
            return (dic["stove_name"] as! String)
        }else{
            let dic:NSDictionary = histroydataArray[row] as! NSDictionary
            
            return (dic["date"] as! String)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        
        if pickerView == frontpickView {
            if dataArray.count == 0 {
                return
            }
            inttimecount = row
            let dic:NSDictionary = dataArray[row] as! NSDictionary
            frontBtn.setTitle("前界面-\(dic["stove_name"] ?? "")", for: .normal)
            behindBtn.setTitle("后界面-\(dic["stove_name"] ?? "")", for: .normal)
            midtitleLabel.text = "炉缸轴截面侵蚀形貌（\(dic["stove_name"] ?? "")）"
            stove_id = dic["stove_id"] as! Int32
            request3()
        }else{
            let dic:NSDictionary = histroydataArray[row] as! NSDictionary
            
            currentDateString = (dic["date"] as! String)
            request3()
        }
        
    }
    
}

extension GYETErosionMorphologyViewController:LMJDropdownMenuDelegate,LMJDropdownMenuDataSource{
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
        
        inttimecount = Int(index)
        let dic:NSDictionary = dataArray[Int(index)] as! NSDictionary
        frontBtnMenu.title = "前界面-\(dic["stove_name"] ?? "")"
        behindBtnMenu.title = "后界面-\(dic["stove_name"] ?? "")"
        midtitleLabel.text = "炉缸轴截面侵蚀形貌（\(dic["stove_name"] ?? "")）"
        stove_id = dic["stove_id"] as! Int32
        request3()
    }
    
}
