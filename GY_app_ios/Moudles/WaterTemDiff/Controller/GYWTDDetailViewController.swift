//
//  GYWTDDetailViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/20.
//

import UIKit

class GYWTDDetailViewController: GYViewController {
    var headdataArray:NSArray = ["实时数据","报警设定"]
    var model:GYWTDDataModel = GYWTDDataModel() {
        didSet{
            titleLable.text = String(format: "【%@】", model.section_name!)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 24, weight: .medium)]
    }
    
    private lazy var bgHeadView:UIView = {
        let view = UIView()
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor(red: 0.52, green: 0.77, blue: 1, alpha: 0.44).cgColor,UIColor(red: 0.42, green: 0.67, blue: 1, alpha: 0).cgColor]
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
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var titleLable:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
    }
    

}

extension GYWTDDetailViewController {
    func setupViews() {
        self.title = model.name
        self.view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        
        self.view.addSubview(bgHeadView)
        self.view.addSubview(titleLable)
        self.view.addSubview(collectionV)
    }
    
    func addLayout() {
        bgHeadView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(123)
        }
        
        titleLable.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topHeight)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(titleLable.snp_bottomMargin).offset(17.5)
            make.bottom.equalTo(-80)
        }
        
    }
}

extension GYWTDDetailViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize.init(width: 100, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWaterTimeDiffHeaderView.indentifier, for: indexPath) as! GYWaterTimeDiffHeaderView
            view.titleStr = headdataArray[indexPath.section] as! String
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWaterTimeDiffFooterView.indentifier, for: indexPath) as! GYWaterTimeDiffFooterView
            
            return view
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            var cell:GYWTDDetailCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDetailCell.indentifier, for: indexPath) as? GYWTDDetailCell
            
            if cell == nil {
                cell = GYWTDDetailCell()
            }
            
            return cell!
        }else{
            var cell:GYWTDDetaiSecCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDetaiSecCell.indentifier, for: indexPath) as? GYWTDDetaiSecCell
            
            if cell == nil {
                cell = GYWTDDetaiSecCell()
            }
            
            return cell!
        }
    }
}
