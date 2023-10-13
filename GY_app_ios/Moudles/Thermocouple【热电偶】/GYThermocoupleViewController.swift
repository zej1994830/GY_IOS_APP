//
//  GYThermocoupleViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/8.
//

import UIKit
import JJCollectionViewRoundFlowLayout_Swift

class GYThermocoupleViewController: GYViewController {
    var headdataArray:NSArray = ["实时","历史","报警","设备巡检"]
    var dataArray:NSArray = [[["rdo_leida","雷达"],["ic_shuju","数据"]],[["rdo_quxian","曲线"],["rdo_shuju","数据"]],[["ic_shishi","实时"],["lk_lishi","历史"]],[["ic_shebei","设备巡检"]]]
    
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
        self.title = "热电偶"
        
        setupViews()
        addLayout()
    }
}

extension GYThermocoupleViewController {
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


extension GYThermocoupleViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,JJCollectionViewDelegateRoundFlowLayout_Swift {
   
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
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
        
    }
}

