//
//  GYWTDDataViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit
import JJCollectionViewRoundFlowLayout_Swift

class GYWTDDataViewController: GYViewController {
    var dataSectionArray:NSArray = []
    var strArray:NSMutableArray = ["温差","入温","出温","流量","热流"]
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: APP.WIDTH, height: 216)
//        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)

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
        requestdata()
    }
    

}

extension GYWTDDataViewController {
    func setupViews() {
        self.title = "数据"
        
        self.view.addSubview(collectionV)
    }
    func addLayout() {
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topHeight + 5)
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
            weakSelf.requestnextdata(array: weakSelf.dataSectionArray)
        }
        
    }
    
    func requestnextdata(array:NSArray){
        //显示项。这里认为只要重新筛选，那么默认全部显示数据
        var partidString:String = ""
        for temp in array {
            let dic:NSDictionary = temp as! NSDictionary
            if partidString.count == 0 {
                //筛选状态
                partidString = String(format: "%d", dic["id"] as! Int64)
            }else{
                partidString = String(format: "%@,%d", partidString,(dic["id"] as! Int64))
            }
        }
        
        let params = ["device_db":GYDeviceData.default.device_db,"partidString":partidString,"rate":"1","typeString":"[0,1,2,3,4]"] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getswcdata, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            let dicc:NSDictionary = dic["data"] as! NSDictionary
            weakSelf.dataSectionArray = dicc["temperature_list"] as! NSArray
            weakSelf.collectionV.reloadData()
        }
    }
}

extension GYWTDDataViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 返回每个 section 的 header 大小
        return CGSize(width: APP.WIDTH, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // 返回每个 section 的 footer 大小
        return CGSizeZero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(APP.WIDTH), height: Int(36 + strArray.count * 36))
    }
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GYWTDDataHeaderView.indentifier, for: indexPath) as! GYWTDDataHeaderView
            view.ClickBlock = {[weak self] strarray in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.strArray = strarray
                weakSelf.collectionV.reloadData()
            }
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
        let dic:NSDictionary = dataSectionArray[indexPath.row] as! NSDictionary
        cell?.titleStr = dic["section_name"] as! String
        cell?.strArray = strArray
        cell?.dataArray = dic["stove_list"] as! NSArray
        return cell!
    }
}
