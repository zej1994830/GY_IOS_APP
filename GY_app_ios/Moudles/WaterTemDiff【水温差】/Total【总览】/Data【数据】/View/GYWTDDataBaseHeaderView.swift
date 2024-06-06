//
//  GYWTDDataHeaderView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit

class GYWTDDataBaseHeaderView: UICollectionReusableView {
    static let indentifier: String = "GYWTDDataBaseHeaderView"
    var titleStr: String = ""{
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var strArray:NSMutableArray = []{
        didSet{
            
            var arr = [wenchaLabel,ruwenLabel,chuwenLabel,liuliangLabel,reliuLabel]
            arr.snp.removeConstraints()
            arr.removeAll()
            wenchaLabel.isHidden = true
            ruwenLabel.isHidden = true
            chuwenLabel.isHidden = true
            liuliangLabel.isHidden = true
            reliuLabel.isHidden = true
            for temp in strArray {
                let str:String = temp as! String
                if str == "温差"{
                    arr.append(wenchaLabel)
                    wenchaLabel.isHidden = false
                }
                if str == "入温"{
                    arr.append(ruwenLabel)
                    ruwenLabel.isHidden = false
                }
                if str == "出温"{
                    arr.append(chuwenLabel)
                    chuwenLabel.isHidden = false
                }
                if str == "流量"{
                    arr.append(liuliangLabel)
                    liuliangLabel.isHidden = false
                }
                if str == "热流"{
                    arr.append(reliuLabel)
                    reliuLabel.isHidden = false
                }
            }
            arr.snp.distributeViewsAlong(axisType: .vertical,fixedSpacing: 0,leadSpacing: 0,tailSpacing: 0)
            arr.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(36)
//                make.top.equalTo(35.5)
            }
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.font = UIFont.systemFont(ofSize: 16 ,weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titlelineLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD")
        return label
    }()
    
    private lazy var bgView:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var wenchaLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "温差"
        return label
    }()
    
    private lazy var ruwenLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "入温"
        return label
    }()
    
    private lazy var chuwenLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "出温"
        return label
    }()
    
    private lazy var liuliangLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "流量"
        return label
    }()
    
    private lazy var reliuLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "热流"
        return label
    }()
    
    private lazy var linelabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD")
        return label
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

extension GYWTDDataBaseHeaderView {
    func setupViews() {
        self.backgroundColor = .white
        
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        
        self.addSubview(titleLabel)
        self.addSubview(titlelineLabel)
        self.addSubview(bgView)
        bgView.addSubview(wenchaLabel)
        bgView.addSubview(ruwenLabel)
        bgView.addSubview(chuwenLabel)
        bgView.addSubview(liuliangLabel)
        bgView.addSubview(reliuLabel)
        self.addSubview(linelabel)
    }
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.top.equalTo(0)
            make.height.equalTo(36)
        }
        
        titlelineLabel.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(35.5)
            make.height.equalTo(1)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        
        wenchaLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.height.equalTo(titleLabel)
        }
        
        ruwenLabel.snp.makeConstraints { make in
            make.top.equalTo(wenchaLabel.snp.bottom)
            make.centerX.height.equalTo(titleLabel)
        }
        
        chuwenLabel.snp.makeConstraints { make in
            make.top.equalTo(ruwenLabel.snp.bottom)
            make.centerX.height.equalTo(titleLabel)
        }
        
        liuliangLabel.snp.makeConstraints { make in
            make.top.equalTo(chuwenLabel.snp.bottom)
            make.centerX.height.equalTo(titleLabel)
        }
        
        reliuLabel.snp.makeConstraints { make in
            make.top.equalTo(liuliangLabel.snp.bottom)
            make.centerX.height.equalTo(titleLabel)
        }
        
        linelabel.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.bottom.equalTo(0)
            make.width.equalTo(1)
        }
    }
}
