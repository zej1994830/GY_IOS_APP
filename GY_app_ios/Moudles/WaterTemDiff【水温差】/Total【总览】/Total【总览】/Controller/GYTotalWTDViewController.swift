//
//  GYTotalWTDViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/7.
//

import UIKit
import SwiftPopMenu

class GYTotalWTDViewController: GYViewController {
    var model:GYWTDBaseModel = GYWTDBaseModel()
    
    var dataSectionArray:NSArray = []
    var datatempSectionArray:NSMutableArray = []
    
    
    var dataArray:NSArray = []{
        didSet {
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(collectionV)
            }
            
            if dataArray.count != 0 {
                let dic:NSDictionary = dataArray.firstObject as! NSDictionary
                timeLabel.text = "      最后更新时间：\(dic["searchDate"] as! String)"
                
            }
        }
    }
    var sectionStr:String = ""
    
    var showDic:NSMutableDictionary = [:]
    private lazy var topView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "段名"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#999999")
        label.text = "一段进水、一进一出、一进二出..."
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var selectBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("筛选", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(UIImage(named: "ic_shaixuan"), for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
//        layout.estimatedItemSize = rellySizeForiPhoneWidth(172.5, 170)
        layout.estimatedItemSize = CGSize(width: (APP.WIDTH - 30) / 2, height: 180)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GYTotalWTDCell.classForCoder(), forCellWithReuseIdentifier: GYTotalWTDCell.indentifier)
        collectionView.register(GYTotalWTDHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYTotalWTDHeaderView.indentifier)
        collectionView.register(GYTotalWTDFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GYTotalWTDFooterView.indentifier)
//        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        collectionView.bounces = false
        return collectionView
    }()

    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#FFFFFF",alpha: 0.85)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水温差总览"
        
        setupViews()
        addLayout()
        requestdata()
        
       let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [self] timer in
            // 这里编写需要执行的自动刷新操作
            requestautodata(array: datatempSectionArray)
       }
    
    }
}

extension GYTotalWTDViewController {
    func setupViews(){
        self.view.addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(contentLabel)
        topView.addSubview(selectBtn)
        self.view.addSubview(collectionV)
        self.view.addSubview(timeLabel)
        
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let image = UIImage.init(named: "my_baojing")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(baojingClick), for: .touchUpInside)
        
        let button2 = UIButton.init(type: .system)
        button2.frame = CGRect.init(x: 40, y: 0, width: 25, height: 25)
        let image2 = UIImage.init(named: "ic_tishi")?.withRenderingMode(.alwaysOriginal)
        button2.setImage(image2, for: .normal)
        button2.addTarget(self, action: #selector(shouClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button),UIBarButtonItem.init(customView: button2)]
    }
    func addLayout(){
        topView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
            make.height.equalTo(49)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.left.equalTo(14)
            make.height.equalTo(22.5)
            make.width.equalTo(36)
        }
        
        selectBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.height.equalTo(28)
            make.width.equalTo(68.5)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.right.equalTo(selectBtn.snp.left)
            make.centerY.equalToSuperview()
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(0)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(22.5 + 48)
//            make.width.equalTo(200)
        }
    }
    
    func requestdata(){
        GYHUD.showGif(view: self.view)
        let params = ["device_db":GYDeviceData.default.device_db,"function_type":0] as [String:Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswclist, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["section_list"] as! NSArray
            weakSelf.datatempSectionArray = NSMutableArray(array: weakSelf.dataSectionArray)
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
        
    }
    
    func requestnextdata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        sectionStr = ""
        showDic.removeAllObjects()
        for temp in array {
            let dic:NSDictionary = temp as! NSDictionary
            if partidString.count == 0 {
                //筛选状态
                partidString = String(format: "%d", dic["id"] as! Int64)
                //段名
                sectionStr = String(format: "%@", dic["name"] as! String)
            }else{
                partidString = String(format: "%@,%d", partidString,(dic["id"] as! Int64))
                sectionStr = String(format: "%@,%@", sectionStr,(dic["name"] as! String))
            }
            
            //每个section对应五个状态 dic = [name:[]]
            showDic.setObject(NSMutableArray(array: ["温差","热流","入温","出温","流量"]), forKey: dic["name"] as! NSCopying)
        }
        
        contentLabel.text = sectionStr
        let params = ["device_db":GYDeviceData.default.device_db,"partidString":partidString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswczonglan, parameters: params) {[weak self] (result) in
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
    
    func requestautodata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        sectionStr = ""
        for temp in array {
            let dic:NSDictionary = temp as! NSDictionary
            if partidString.count == 0 {
                //筛选状态
                partidString = String(format: "%d", dic["id"] as! Int64)
                //段名
                sectionStr = String(format: "%@", dic["name"] as! String)
            }else{
                partidString = String(format: "%@,%d", partidString,(dic["id"] as! Int64))
                sectionStr = String(format: "%@,%@", sectionStr,(dic["name"] as! String))
            }
        }
        
        contentLabel.text = sectionStr
        let params = ["device_db":GYDeviceData.default.device_db,"partidString":partidString] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswczonglan, parameters: params) {[weak self] (result) in
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
}

extension GYTotalWTDViewController {
    @objc func shouClick(){
        let vc = GYUnitViewController()
        self.zej_present(vc, vcTransitionDelegate: ZEJRollDownTransitionDelegate()) {
            
        }
    }
    
    @objc func baojingClick(){
        let vc = GYWTDWarnViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func selectClick(){
        let vc = GYSelectWaterViewController()
        vc.dataArray = NSMutableArray(array: dataSectionArray)
        vc.tempArray = NSMutableArray(array: datatempSectionArray)
        vc.ClickBlock = { [weak self] array in
            guard let weakSelf = self else {
                return
            }
            weakSelf.datatempSectionArray = NSMutableArray(array: array)
            //拿回来的数组存在顺序错乱，是否排列以后再定
            weakSelf.requestnextdata(array: array)
        }
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
    
}


extension GYTotalWTDViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let diccc:NSDictionary = dataArray[section] as! NSDictionary
        let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
        return tempmodel.stove_list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.init(width: 100, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYTotalWTDHeaderView.indentifier, for: indexPath) as! GYTotalWTDHeaderView
            
            view.index = indexPath
            view.superself = self
            view.supercollectV = collectionView
            let diccc:NSDictionary = dataArray[indexPath.section] as! NSDictionary
            let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
            view.dataModel = GYWTDDataModel.deserialize(from: tempmodel.stove_list[indexPath.row] as? NSDictionary)
            view.dataStrArray = showDic[tempmodel.section_name] as! NSMutableArray 
            //显示项，当前section的
            view.ClickBlock = {[weak self] typearray in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showDic.setObject(typearray, forKey: tempmodel.section_name as NSCopying)
                weakSelf.collectionV.reloadData()
            }
            
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYTotalWTDFooterView.indentifier, for: indexPath) as! GYTotalWTDFooterView
            view.backgroundColor = .white
            return view
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYTotalWTDCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYTotalWTDCell.indentifier, for: indexPath) as? GYTotalWTDCell
        
        if cell == nil {
            cell = GYTotalWTDCell()
        }
        
        //拿到section上的显示项状态
        
        let diccc:NSDictionary = dataArray[indexPath.section] as! NSDictionary
        let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
        cell?.dataModel = GYWTDDataModel.deserialize(from: tempmodel.stove_list[indexPath.row] as? NSDictionary)
        let tempArray:NSMutableArray = showDic[cell?.dataModel?.section_name] as? NSMutableArray ?? []
        cell?.dataStrArray = tempArray
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diccc:NSDictionary = dataArray[indexPath.section] as! NSDictionary
        let tempmodel:GYWTDBaseModel = GYWTDBaseModel.deserialize(from: diccc)!
        
        let vc = GYWTDDetailViewController()
        vc.model = GYWTDDataModel.deserialize(from: tempmodel.stove_list[indexPath.row] as? NSDictionary)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let diccc:NSDictionary = dataArray[indexPath.section] as! NSDictionary
        let tempArray:NSMutableArray = showDic[diccc["section_name"]] as? NSMutableArray ?? []
        return CGSize(width: (APP.WIDTH - 30) / 2, height: Double(tempArray.count * 27 + 35 + 10) )
    }
}

