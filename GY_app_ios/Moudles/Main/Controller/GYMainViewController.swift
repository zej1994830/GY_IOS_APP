//
//  GYMainViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import UIKit
import FSPagerView
import SwiftPopMenu
class GYMainViewController: GYViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isHiddenNavigationBar = true
    }
    var bannerarray:NSArray = []
    var deviceArray:NSMutableArray = []
    //主页六个cell。默认布局
    var mainStrArray:NSArray = [["main_shuiwen","水温差","#8494FF","#476DFC"],["main_luke","炉壳温度","#FF9090","#FF4848"],["main_liuliang","流量计","#03D6A3","#02BE8B"],["main_qinshi","侵蚀结厚","#FFB23F","#F9861B"],["main_redian","热电偶","#C082FF","#A75FF0"],["main_fengkou","风口套","#4DD9F8","#12AAFF"]]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(locationSuccess(_:)), name: NotificationConstant.locationSuccess, object: nil)
        
        setupViews()
        addLayout()

    }
    private lazy var bgHeadView:UIView = {
        let view = UIView()
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor(red: 0.52, green: 0.77, blue: 1, alpha: 0.44).cgColor,UIColor(red: 0.42, green: 0.67, blue: 1, alpha: 0).cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 205)
        view.layer.insertSublayer(caGradientLayer, at: 0)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var leftBtn:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(leftbtnClick), for: .touchUpInside)
        return btn
    }()

    private lazy var leftImageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "mian_vector")
        return imagev
    }()
    
    private lazy var rightbtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "my_baojing"), for: .normal)
        return btn
    }()
    
    private lazy var deviceView:SwiftPopMenu = {
        let parameters:[SwiftPopMenuConfigure] = [
            .popMenuAlpha(0)
        ]
        
        let view = SwiftPopMenu.init(menuWidth: 250, arrow: CGPoint(x: 80, y: topHeight - 10), datas: GYUserBaseInfoData.default.device_listname as! [(icon: String, title: String)],configures: parameters)
        view.didSelectMenuBlock = { [weak self](index:Int) in
            guard let weakSelf = self else{
                return
            }
            let dic:NSDictionary = GYUserBaseInfoData.default.device_list[index] as! NSDictionary
            weakSelf.leftBtn.setTitle(dic["device_name"] as? String, for: .normal)
        }
        return view
    }()
    
    private lazy var bannerView:FSPagerView = {
        let view = FSPagerView()
        view.isInfinite = true
        view.automaticSlidingInterval = 3
        view.delegate = self
        view.dataSource = self
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var pageController: FSPageControl = {
        let view = FSPageControl()
        view.numberOfPages = 2
        view.currentPage = 0
        view.contentHorizontalAlignment = .right
        return view
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = GYCustomFlowLayout.init()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = rellySizeForiPhoneWidth(167.5, 95)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15.rellyWidthNumber, bottom: 0, right: 15.rellyWidthNumber)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GYMainViewCell.classForCoder(), forCellWithReuseIdentifier: GYMainViewCell.indentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

}
extension GYMainViewController {
    @objc private func locationSuccess(_ notification: Notification){
        
        //延迟一下，否则转圈gif错乱
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            GYHUD.showGif(view: self.view)
            let params = ["user_id": GYUserBaseInfoData.default.user_id]
            GYNetworkManager.share.requestData(.get, api: Api.getuserinfo,parameters: params) {[weak self] (result) in
                guard let weakSelf = self else{
                    return
                }
                
                let rresult = result as! [String:Any]
                let data: NSDictionary = rresult["data"] as! NSDictionary
                let userBaseInfo = GYUserBaseInfoData.getUserInfo(data: data)
                CommonCache.cacheData(userBaseInfo, key: CacheKey.userDataInfoCacheKey)
                weakSelf.nextrequest(device_db: GYDeviceData.default.device_db)
                weakSelf.view.addSubview(weakSelf.deviceView)
                weakSelf.deviceView.dismiss()
                weakSelf.leftBtn.setTitle(GYDeviceData.default.device_name, for: .normal)
            }
        }
    }
    
    func nextrequest(device_db: String) {
        let params = ["user_type":GYDeviceData.default.device_type,"device_db":GYDeviceData.default.device_db] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getbanner, parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let rresult = result as! [String:Any]
            let data: NSDictionary = rresult["data"] as! NSDictionary
            weakSelf.bannerarray = data["new_list"] as! NSArray
            weakSelf.pageController.numberOfPages = weakSelf.bannerarray.count
            weakSelf.bannerView.reloadData()
        }
    }
    
    @objc func deviceClick() {
        
    }
     
    func setupViews() {
//        self.view.addSubview(deviceView)
        self.view.addSubview(bgHeadView)
        self.view.addSubview(leftBtn)
        self.view.addSubview(leftImageV)
        self.view.addSubview(rightbtn)
        self.view.addSubview(bannerView)
        self.view.addSubview(pageController)
        self.view.addSubview(collectionV)
        
        self.isHiddenBgView = true
    }
    func addLayout() {
        bgHeadView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(205)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(25)
            make.top.equalTo(topHeight - 35)
        }
        
        leftImageV.snp.makeConstraints { make in
            make.centerY.equalTo(leftBtn)
            make.left.equalTo(leftBtn.snp.right).offset(8.5)
            make.width.equalTo(9)
            make.height.equalTo(6.37)
        }
        
        rightbtn.snp.makeConstraints { make in
            make.right.equalTo(-25)
            make.centerY.equalTo(leftBtn)
            make.width.equalTo(16)
            make.height.equalTo(17)
        }
        
        bannerView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(leftBtn.snp.bottom).offset(30)
            make.height.equalTo(165)
        }
        
        pageController.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.bottom.equalTo(bannerView)
            make.right.equalTo(-30)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(bannerView.snp.bottom).offset(15)
        }
    }
}

extension GYMainViewController:  FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerarray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let data:NSDictionary = bannerarray[index] as! NSDictionary
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.imageView?.sd_setImage(with: URL.init(string: String(format: "%@%@", APP.API_IMGAE_SERVER,data["img_url"] as! CVarArg)))
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageController.currentPage = pagerView.currentIndex
    }
    

    
    @objc func leftbtnClick() {
        deviceView.show()
    }
}
extension GYMainViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYMainViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYMainViewCell.indentifier, for: indexPath) as? GYMainViewCell
        
        if cell == nil {
            cell = GYMainViewCell()
        }
        
        cell?.dataarray = mainStrArray[indexPath.row] as! NSArray
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //水温差
            let vc = GYWaterTemDiffViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1 {
            //炉壳温度
            let vc = GYFurnaceShellMainViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            //流量计
        }else if indexPath.row == 3 {
            //侵蚀厚度
            let vc = GYErosionThicknessMainViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4 {
            //热电偶
        }else if indexPath.row == 5 {
            //风口套
        }
        
    }

}

