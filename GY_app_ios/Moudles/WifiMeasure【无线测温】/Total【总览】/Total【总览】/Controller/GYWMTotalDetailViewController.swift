//
//  GYWMTotalDetailViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/5/31.
//

import UIKit

class GYWMTotalDetailViewController: GYViewController {
    var headdataArray:NSArray = ["实时数据","报警设定"]
    //实时数据
    var dataArray:NSArray = []
    //报警设定
    var dataArray2:NSArray = []
    var model:GYWMDataModel = GYWMDataModel() {
        didSet{
            titleLable.text = String(format: "【%@】", model.name!)
            
            dataArray = [["A1(°C)",model.A1_value],["B1(°C)",model.B1_value],["C1(°C)",model.C1_value],["A2(°C)",model.A2_value],["B2(°C)",model.B2_value],["C2(°C)",model.C2_value],["A3(°C)",model.A3_value],["B3(°C)",model.B3_value],["C3(°C)",model.C3_value],["D1(°C)",model.D1_value],["D2(°C)",model.D2_value],["D3(°C)",model.D3_value],["D4(°C)",model.D4_value],["D5(°C)",model.D5_value]]
            dataArray2 = [["A1",String(format: "低报警：%d", model.A1_L!),
                           String(format: "低低报警：%d", model.A1_LL!),
                             String(format: "高报警：%d", model.A1_H!),
                           String(format: "高高报警：%d", model.A1_HH!),
                           String(format: "主机地址：%d", model.A1_MA!),
                           String(format: "子机地址：%d", model.A1_SA!)],
                          ["B1",String(format: "低报警：%d", model.B1_L!),
                              String(format: "低低报警：%d", model.B1_LL!),
                                String(format: "高报警：%d", model.B1_H!),
                              String(format: "高高报警：%d", model.B1_HH!),
                              String(format: "主机地址：%d", model.B1_MA!),
                              String(format: "子机地址：%d", model.B1_SA!)],
                          ["C1",String(format: "低报警：%d", model.C1_L!),
                              String(format: "低低报警：%d", model.C1_LL!),
                                String(format: "高报警：%d", model.C1_H!),
                              String(format: "高高报警：%d", model.C1_HH!),
                              String(format: "主机地址：%d", model.C1_MA!),
                              String(format: "子机地址：%d", model.C1_SA!)],
                          ["A2",String(format: "低报警：%d", model.A2_L!),
                              String(format: "低低报警：%d", model.A2_LL!),
                                String(format: "高报警：%d", model.A2_H!),
                              String(format: "高高报警：%d", model.A2_HH!),
                              String(format: "主机地址：%d", model.A2_MA!),
                              String(format: "子机地址：%d", model.A2_SA!)],
                          ["B2",String(format: "低报警：%d", model.B2_L!),
                              String(format: "低低报警：%d", model.B2_LL!),
                                String(format: "高报警：%d", model.B2_H!),
                              String(format: "高高报警：%d", model.B2_HH!),
                              String(format: "主机地址：%d", model.B2_MA!),
                              String(format: "子机地址：%d", model.B2_SA!)],
                          ["C2",String(format: "低报警：%d", model.C2_L!),
                              String(format: "低低报警：%d", model.C2_LL!),
                                String(format: "高报警：%d", model.C2_H!),
                              String(format: "高高报警：%d", model.C2_HH!),
                              String(format: "主机地址：%d", model.C2_MA!),
                              String(format: "子机地址：%d", model.C2_SA!)],
                          ["A3",String(format: "低报警：%d", model.A3_L!),
                              String(format: "低低报警：%d", model.A3_LL!),
                                String(format: "高报警：%d", model.A3_H!),
                              String(format: "高高报警：%d", model.A3_HH!),
                              String(format: "主机地址：%d", model.A3_MA!),
                              String(format: "子机地址：%d", model.A3_SA!)],
                          ["B3",String(format: "低报警：%d", model.B3_L!),
                              String(format: "低低报警：%d", model.B3_LL!),
                                String(format: "高报警：%d", model.B3_H!),
                              String(format: "高高报警：%d", model.B3_HH!),
                              String(format: "主机地址：%d", model.B3_MA!),
                              String(format: "子机地址：%d", model.B3_SA!)],
                          ["C3",String(format: "低报警：%d", model.C3_L!),
                              String(format: "低低报警：%d", model.C3_LL!),
                                String(format: "高报警：%d", model.C3_H!),
                              String(format: "高高报警：%d", model.C3_HH!),
                              String(format: "主机地址：%d", model.C3_MA!),
                              String(format: "子机地址：%d", model.C3_SA!)],
                          ["D1",String(format: "低报警：%d", model.D1_L!),
                              String(format: "低低报警：%d", model.D1_LL!),
                                String(format: "高报警：%d", model.D1_H!),
                              String(format: "高高报警：%d", model.D1_HH!),
                              String(format: "主机地址：%d", model.D1_MA!),
                              String(format: "子机地址：%d", model.D1_SA!)],
                          ["D2",String(format: "低报警：%d", model.D2_L!),
                              String(format: "低低报警：%d", model.D2_LL!),
                                String(format: "高报警：%d", model.D2_H!),
                              String(format: "高高报警：%d", model.D2_HH!),
                              String(format: "主机地址：%d", model.D2_MA!),
                              String(format: "子机地址：%d", model.D2_SA!)],
                          ["D3",String(format: "低报警：%d", model.D3_L!),
                              String(format: "低低报警：%d", model.D3_LL!),
                                String(format: "高报警：%d", model.D3_H!),
                              String(format: "高高报警：%d", model.D3_HH!),
                              String(format: "主机地址：%d", model.D3_MA!),
                              String(format: "子机地址：%d", model.D3_SA!)],
                          ["D4",String(format: "低报警：%d", model.D4_L!),
                              String(format: "低低报警：%d", model.D4_LL!),
                                String(format: "高报警：%d", model.D4_H!),
                              String(format: "高高报警：%d", model.D4_HH!),
                              String(format: "主机地址：%d", model.D4_MA!),
                              String(format: "子机地址：%d", model.D4_SA!)],
                          ["D5",String(format: "低报警：%d", model.D5_L!),
                              String(format: "低低报警：%d", model.D5_LL!),
                                String(format: "高报警：%d", model.D5_H!),
                              String(format: "高高报警：%d", model.D5_HH!),
                              String(format: "主机地址：%d", model.D5_MA!),
                              String(format: "子机地址：%d", model.D5_SA!)]
            ]
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
        collectionView.register(GYWMDetaiSecCell.classForCoder(), forCellWithReuseIdentifier: GYWMDetaiSecCell.indentifier)
        collectionView.register(GYWaterTimeDiffHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYWaterTimeDiffHeaderView.indentifier2)
        collectionView.register(GYWaterTimeDiffFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GYWaterTimeDiffFooterView.indentifier2)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        return collectionView
    }()
    
    private lazy var titleLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
    }

}

extension GYWMTotalDetailViewController {
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
        let vc = GYWMTotalTrendViewController()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GYWMTotalDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
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
             
            var cell:GYWMDetaiSecCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWMDetaiSecCell.indentifier, for: indexPath) as? GYWMDetaiSecCell
            
            if cell == nil {
                cell = GYWMDetaiSecCell()
            }
            cell?.titleStr = array[0] as! String
            cell?.valueStr = array[1] as! String
            cell?.value2Str = array[2] as! String
            cell?.value3Str = array[3] as! String
            cell?.value4Str = array[4] as! String
            cell?.value5Str = array[5] as! String
            cell?.value6Str = array[6] as! String
            return cell!
        }
    }
}
