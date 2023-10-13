//
//  GYWaterTimeDiffHeaderView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/7.
//

import UIKit

class GYWaterTimeDiffHeaderView: UICollectionReusableView {
    static let indentifier: String = "GYWaterTimeDiffHeaderView"
    static let indentifier2: String = "GYWaterTimeDiffHeaderView2"
    
    var titleStr:String = ""{
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.layer.cornerRadius = 2.5
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "总览"
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

extension GYWaterTimeDiffHeaderView {
    func setupViews(){
        self.addSubview(iconLabel)
        self.addSubview(titleLabel)
    }
    
    func addLayout(){
        iconLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(25.5)
            make.width.equalTo(5)
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.left.equalTo(iconLabel.snp.right).offset(6.5)
            make.centerY.equalTo(iconLabel)
        }
        
    }
    
}
