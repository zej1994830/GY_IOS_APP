//
//  GYWTDDeviceAddressViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/23.
//

import UIKit

class GYWTDDeviceAddressViewController: GYViewController {
    var deviceDataArray:NSArray = []
    var dataArray:NSArray = []
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "设备地址："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var nameBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("设备地址43", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 105, bottom: 0, right: -25)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 5)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = rellySizeForiPhoneWidth(165, 60)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 0, right: 15)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GYWTDDeviceAdressCell.classForCoder(), forCellWithReuseIdentifier: GYWTDDeviceAdressCell.indentifier)
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
        request()
    }
}

extension GYWTDDeviceAddressViewController {
    func setupViews() {
        self.title = "设备地址"
        
        self.view.addSubview(headView)
        headView.addSubview(titleLabel)
        headView.addSubview(nameBtn)
        self.view.addSubview(collectionV)
        self.view.addSubview(namepickView)
    }
    
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
            make.height.equalTo(63)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(125)
            make.centerY.equalToSuperview()
        }
     
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(headView.snp.bottom).offset(5)
        }
        
        namepickView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func request() {
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":1] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getdeviceaddresslist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.deviceDataArray = dicc["temperature_list"] as! NSArray
            weakSelf.namepickView.reloadAllComponents()
            
            let diccc:NSDictionary = weakSelf.deviceDataArray.firstObject as! NSDictionary
            weakSelf.nameBtn.setTitle(diccc["masterAddress"] as? String, for: .normal)
            weakSelf.requestnextdata(dic: diccc)
        }
    }
    
    func requestnextdata(dic:NSDictionary) {
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":1,"deviceAddr":dic["masterAddressNumber"] ?? 0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.gettaglistbydeviceaddr, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataArray = dicc["temperature_list"] as! NSArray
            weakSelf.collectionV.reloadData()
        }
    }
    
    @objc func nameBtnClick() {
        namepickView.isHidden = false
    }
}

extension GYWTDDeviceAddressViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWTDDeviceAdressCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDeviceAdressCell.indentifier, for: indexPath) as? GYWTDDeviceAdressCell
        
        if cell == nil {
            cell = GYWTDDeviceAdressCell()
        }
        let dic:NSDictionary = dataArray[indexPath.row] as! NSDictionary
        cell?.isNor = ((dic["isException"] as? Int) != nil)
        cell?.titleStr = dic["name"] as! String
        return cell!
    }
}

extension GYWTDDeviceAddressViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deviceDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dic:NSDictionary = deviceDataArray[row] as! NSDictionary
        return dic["masterAddress"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dic:NSDictionary = deviceDataArray[row] as! NSDictionary
        requestnextdata(dic: dic)
        nameBtn.setTitle(dic["masterAddress"] as? String, for: .normal)
        pickerView.isHidden = true
    }
}
