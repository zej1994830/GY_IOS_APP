//
//  GYWTDDataViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit
import JJCollectionViewRoundFlowLayout_Swift


class GYWTDDataViewController: GYViewController {
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: APP.WIDTH, height: 216)
//        layout.sectionHeadersPinToVisibleBounds = true
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWTDDataCell.classForCoder(), forCellWithReuseIdentifier: GYWTDDataCell.indentifier)
        collectionView.register(GYWTDDataHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYWTDDataHeaderView.indentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
        
    }
    

}

extension GYWTDDataViewController {
    func setupViews() {
        self.title = "数据"
        
        self.view.addSubview(collectionV)
    }
    func addLayout() {
        
        
        collectionV.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }
}

extension GYWTDDataViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 返回每个 section 的 header 大小
        return CGSize(width: APP.WIDTH, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 返回每个 section 的 footer 大小
        return CGSizeZero
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWTDDataHeaderView.indentifier, for: indexPath) as! GYWTDDataHeaderView
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYTotalWTDFooterView.indentifier, for: indexPath) as! GYTotalWTDFooterView
            view.backgroundColor = .clear
            return view
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWTDDataCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDataCell.indentifier, for: indexPath) as? GYWTDDataCell
        
        if cell == nil {
            cell = GYWTDDataCell()
        }
        
        return cell!
    }
}
