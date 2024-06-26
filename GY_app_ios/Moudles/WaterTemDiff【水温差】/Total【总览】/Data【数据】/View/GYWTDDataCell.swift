//
//  GYWTDDataCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit
import HandyJSON
class GYWTDDataCell: UICollectionViewCell {
    static let indentifier: String = "GYMainViewCell"
    var tempheaderView:GYWTDDataBaseHeaderView = GYWTDDataBaseHeaderView()
    var dataArray:NSArray = []{
        didSet{
            collectionV.snp.updateConstraints { make in
                make.height.equalTo(36 + strArray.count * 36)
            }
            collectionV.reloadData()
        }
    }
    var titleStr:String = ""
    var strArray:NSMutableArray = []
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 119, height: 216)
        layout.sectionHeadersPinToVisibleBounds = true
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWTDDataBaseCell.classForCoder(), forCellWithReuseIdentifier: GYWTDDataBaseCell.indentifier)
        collectionView.register(GYWTDDataBaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GYWTDDataBaseHeaderView.indentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension GYWTDDataCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func setupViews() {
        self.contentView.addSubview(collectionV)
        self.contentView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD")
    }
    func addLayout() {
        collectionV.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
            make.height.equalTo(36 + strArray.count * 36)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 119, height: Int(36 + strArray.count * 36))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 返回每个 section 的 header 大小
        return CGSize(width: 119, height: 36 + strArray.count * 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 返回每个 section 的 footer 大小
        return CGSize.zero
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWTDDataBaseHeaderView.indentifier, for: indexPath) as! GYWTDDataBaseHeaderView
            tempheaderView = view
            view.titleStr = titleStr
            view.strArray = strArray
            return view
        }else{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYTotalWTDFooterView.indentifier, for: indexPath) as! GYTotalWTDFooterView
            view.backgroundColor = .white
            return view
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWTDDataBaseCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDDataBaseCell.indentifier, for: indexPath) as? GYWTDDataBaseCell
        if cell == nil {
            cell = GYWTDDataBaseCell()
        }
        cell?.strArray = strArray
        cell?.model = GYWTDDataData.deserialize(from: dataArray[indexPath.row] as? NSDictionary)
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 && !tempheaderView.layer.masksToBounds{
            tempheaderView.layer.masksToBounds = true
        }
        if scrollView.contentOffset.x != 0 && tempheaderView.layer.masksToBounds {
            tempheaderView.layer.masksToBounds = false
        }
    }
   
}
