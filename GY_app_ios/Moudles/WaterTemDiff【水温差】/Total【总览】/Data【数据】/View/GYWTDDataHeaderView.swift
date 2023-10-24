//
//  GYWTDDataHeaderView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit

class GYWTDDataHeaderView: UICollectionReusableView {
    static let indentifier: String = "GYWTDDataHeaderView"
    var ClickBlock: ((NSMutableArray)->())? = nil
    
    private lazy var optionLabel:UILabel = {
        let label = UILabel()
        label.text = "选项："
        return label
    }()
    
    private lazy var wenchaBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setTitle(" 温差", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var ruwenBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setTitle(" 入温", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var chuwenBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setTitle(" 出温", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var liuliangBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setTitle(" 流量", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var reliuBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setTitle(" 热流", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
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

extension GYWTDDataHeaderView {
    func setupViews() {
        self.backgroundColor = .white
        self.addSubview(optionLabel)
        self.addSubview(wenchaBtn)
        self.addSubview(ruwenBtn)
        self.addSubview(chuwenBtn)
        self.addSubview(liuliangBtn)
        self.addSubview(reliuBtn)
    }
    func addLayout() {
        optionLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        wenchaBtn.snp.makeConstraints { make in
            make.centerY.equalTo(optionLabel)
            make.width.equalTo(60)
            make.left.equalTo(optionLabel.snp_rightMargin).offset(10)
        }
        
        ruwenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(optionLabel)
            make.left.equalTo(wenchaBtn.snp_rightMargin).offset((APP.WIDTH - 265) / 2)
            make.width.equalTo(wenchaBtn)
        }
        
        chuwenBtn.snp.makeConstraints { make in
            make.centerY.equalTo(optionLabel)
            make.right.equalTo(-33.5)
            make.width.equalTo(wenchaBtn)
        }
        
        liuliangBtn.snp.makeConstraints { make in
            make.left.equalTo(wenchaBtn)
            make.top.equalTo(wenchaBtn.snp_bottomMargin).offset(25)
            make.width.equalTo(wenchaBtn)
        }
        
        reliuBtn.snp.makeConstraints { make in
            make.left.equalTo(ruwenBtn)
            make.centerY.equalTo(liuliangBtn)
            make.width.equalTo(wenchaBtn)
            make.bottom.equalTo(-13.5)
        }
    }
    
    @objc func btnClick(_ button:UIButton) {
        button.isSelected = !button.isSelected
        
        var str:NSMutableArray = []
        if wenchaBtn.isSelected {
            str.add("温差")
        }
        if ruwenBtn.isSelected {
            str.add("入温")
        }
        if chuwenBtn.isSelected {
            str.add("出温")
        }
        if liuliangBtn.isSelected {
            str.add("流量")
        }
        if reliuBtn.isSelected {
            str.add("热流")
        }
        
        if let block = ClickBlock{
            block(str)
        }
    }
}
