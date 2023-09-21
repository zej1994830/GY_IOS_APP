//
//  GYWaterTemDiffViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/6.
//

import UIKit
import JJCollectionViewRoundFlowLayout_Swift

class GYWaterTemDiffViewController: GYViewController {
    var headdataArray:NSArray = ["总览","趋势","报警","数据","设备巡检"]
    var dataArray:NSArray = [[["ic_zonglan","总览"],["ic_shuju","数据"],["ic_leida","雷达"]],[["ic_wencha","温差"],["ic_rushui","入温"],["ic_chushui","出温"],["ic_liuliang","流量"],["ic_reliu","热流"]],[["ic_shishi","实时"],["ic_lishi","历史"]],[["ic_fenzhong","分钟"],["ic_xiaoshi","小时"],["ic_ri","日"],["ic_yue","月"]],[["ic_shebei","设备巡检"]]]
    
    private lazy var collectionView: UICollectionView = {
        let layout = JJCollectionViewRoundFlowLayout_Swift.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30.rellyWidthNumber, bottom: 0, right: 30.rellyWidthNumber)
        layout.itemSize = rellySizeForiPhoneWidth(49, 80)
        layout.minimumLineSpacing = 13.25
        layout.minimumInteritemSpacing = 31.5
        layout.scrollDirection = .vertical
        layout.isCalculateHeader = true
        layout.isCalculateFooter = true
        
        let view = UICollectionView.init(frame: CGRectZero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.register(GYWaterTemDiffCell.self, forCellWithReuseIdentifier: "GYWaterTemDiffCell")
        view.register(GYWaterTimeDiffHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYWaterTimeDiffHeaderView.indentifier)
        view.register(GYWaterTimeDiffFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GYWaterTimeDiffFooterView.indentifier)
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "水温差"
        self.view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        
        setupViews()
        addLayout()
    }
}

extension GYWaterTemDiffViewController {
    func setupViews(){
        self.view.addSubview(collectionView)
    }
    
    func addLayout(){
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.equalTo(topHeight + 5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
    }
}


extension GYWaterTemDiffViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,JJCollectionViewDelegateRoundFlowLayout_Swift {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, borderEdgeInsertsForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.init(width: 100, height: 65)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 100, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, configModelForSectionAtIndex section: Int) -> JJCollectionViewRoundConfigModel_Swift {
        let model = JJCollectionViewRoundConfigModel_Swift.init()
        model.backgroundColor = .white
        model.cornerRadius = 5
        return model
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 5
        case 2:
            return 2
        case 3:
            return 4
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWaterTemDiffCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWaterTemDiffCell.indentifier, for: indexPath) as? GYWaterTemDiffCell
        
        if cell == nil {
            cell = GYWaterTemDiffCell()
        }
        cell?.dataArray = (dataArray[indexPath.section] as! NSArray)[indexPath.row] as! NSArray
        
        return cell ?? UICollectionViewCell()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = GYTotalWTDViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

