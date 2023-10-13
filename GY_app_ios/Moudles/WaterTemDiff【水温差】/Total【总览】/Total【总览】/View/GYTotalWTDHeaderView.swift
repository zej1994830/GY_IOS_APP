//
//  GYTotalWTDHeaderView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/11.
//

import UIKit

class GYTotalWTDHeaderView: UICollectionReusableView {
    static let indentifier: String = "GYTotalWTDHeaderView"
    var sroll_contset:CGFloat = 0
    var supercollectV:UICollectionView? = nil
    var index:IndexPath = IndexPath()
    var superself:GYTotalWTDViewController? = nil
    var ClickBlock: ((NSMutableArray)->())? = nil
    //先源后缓存
    var dataStrArray:NSMutableArray = []
    
    var dataModel:GYWTDDataModel? = nil {
        didSet{
            titleLabel.text = dataModel?.section_name
        }
    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        return view
    }()
    
    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.layer.cornerRadius = 2.5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "一进一出"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var showBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("显示项 ", for: .normal)
        btn.setTitleColor(UIColor.UIColorFromHexvalue(color_vaule: "#999999"), for: .normal)
        btn.setImage(UIImage(named: "ic_vector"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: -50)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        btn.addTarget(self, action: #selector(showBtnClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addLayout()
        
        self.backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GYTotalWTDHeaderView {
    func setupViews() {
        self.addSubview(bgView)
        self.addSubview(iconLabel)
        self.addSubview(titleLabel)
        self.addSubview(showBtn)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(5)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.left.equalTo(15)
            make.width.equalTo(5)
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconLabel.snp.right).offset(6.5)
            make.centerY.equalTo(iconLabel)
        }
        
        showBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(iconLabel)
        }
    }
        
}

extension GYTotalWTDHeaderView {
    @objc func showBtnClick() {
                
        //当前section滑动到顶部
        supercollectV?.scrollToItem(at: index, at: .top, animated: true)
        let vc = GYSelectWTDViewController()
        //得到本View在屏幕上的坐标，根据此坐标，确定弹框坐标
        let rect = supercollectV!.convert(self.frame, to: superself!.view)
//        vc.view_origin_y = rect.origin.y
        vc.view_origin_y = superself!.topHeight + 49
        vc.ClickBlock = {[weak self] typearray in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dataStrArray = NSMutableArray(array: typearray)
            if let block = weakSelf.ClickBlock{
                block(typearray)
            }
        }
        vc.datatypeArray = dataStrArray
        Global_TopViewController!.zej_present(vc, vcTransitionDelegate: ZEJRollDownTransitionDelegate()) {
            
        }
    }
}
