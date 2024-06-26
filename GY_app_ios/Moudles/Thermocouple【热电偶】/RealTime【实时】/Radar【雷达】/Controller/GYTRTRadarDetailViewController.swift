//
//  GYTRTRadarDetailViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/29.
//

import UIKit

class GYTRTRadarDetailViewController: GYViewController {
    var headdataArray:NSArray = ["实时数据","报警设定"]
    //实时数据
    var dataArray:NSArray = []
    //报警设定
    var dataArray2:NSArray = []
    var model:GYRTRadarData = GYRTRadarData() {
        didSet{
            dataArray = [["角度(°)",Double(model.insertion_angle!)],["插入深度(m)",Double(model.insertion_height!)],["温度(°)",Double(model.temperature!)],["标高(m)",Double(model.elevation!)],[" ",-9999],[" ",-9999]]
            dataArray2 = [["温度",String(format: "超低报警：%@", ""),String(format: "低低报警：%@", model.ll_T!)],["",String(format: "低报警：%@", model.l_T!),String(format: "高报警：%@", model.h_T!)],["",String(format: "高高报警：%@", model.hh_T!),String(format: "超高报警：%@", "")],["",String(format: "超高高报警：%@", ""),String(format: "")]]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 24, weight: .medium)]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: .medium)]
    }
    
    private lazy var bgHeadView:UIView = {
        let view = UIView()
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor(red: 0.52, green: 0.77, blue: 1, alpha: 0.44).cgColor,UIColor.white.cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 123)
        view.layer.insertSublayer(caGradientLayer, at: 0)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = rellySizeForiPhoneWidth(124, 81)
//        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 22, bottom: 0, right: -22)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWTDDetailCell.classForCoder(), forCellWithReuseIdentifier: GYWTDDetailCell.indentifier)
        collectionView.register(GYWTDDetaiSecCell.classForCoder(), forCellWithReuseIdentifier: GYWTDDetaiSecCell.indentifier)
        collectionView.register(GYWaterTimeDiffHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYWaterTimeDiffHeaderView.indentifier2)
        collectionView.register(GYWaterTimeDiffFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GYWaterTimeDiffFooterView.indentifier2)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        return collectionView
    }()
    
    private lazy var trendBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.setTitle("趋势", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(trendBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "热电偶"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
    }

}

extension GYTRTRadarDetailViewController {
    func setupViews() {
        self.title = model.name
        
        self.view.addSubview(bgHeadView)
        self.view.addSubview(titleLable)
        self.view.addSubview(collectionV)
        self.view.addSubview(trendBtn)
    }
    
    func addLayout() {
        bgHeadView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(123)
        }
        
        titleLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(92)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(123)
            make.bottom.equalTo(-80)
        }
        
        trendBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.bottom.equalTo(-15)
            make.height.equalTo(44)
        }
    }
    
    @objc func trendBtnClick() {
        let vc = GYTRTRadarDetailTrendViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GYTRTRadarDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return dataArray.count
        }else{
            return dataArray2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.init(width: 100, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWaterTimeDiffHeaderView.indentifier2, for: indexPath) as! GYWaterTimeDiffHeaderView
            view.titleStr = headdataArray[indexPath.section] as! String
            view.backgroundColor = .white
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWaterTimeDiffFooterView.indentifier2, for: indexPath) as! GYWaterTimeDiffFooterView
            
            return view
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section == 0 {
            
            let array:NSArray = dataArray[indexPath.row] as! NSArray
            
            var cell:GYWTDDetailCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDetailCell.indentifier, for: indexPath) as? GYWTDDetailCell
            
            if cell == nil {
                cell = GYWTDDetailCell()
            }
            cell?.titleStr = array[0] as! String
            cell?.valueStr = array[1] as! Double
            return cell!
        }else{
            let array:NSArray = dataArray2[indexPath.row] as! NSArray
            
            var cell:GYWTDDetaiSecCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDetaiSecCell.indentifier, for: indexPath) as? GYWTDDetaiSecCell
            
            if cell == nil {
                cell = GYWTDDetaiSecCell()
            }
            cell?.titleStr = array[0] as! String
            cell?.valueStr = array[1] as! String
            cell?.value2Str = array[2] as! String
        
            return cell!
        }
    }
}
