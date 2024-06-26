//
//  GYWMMidCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/6/3.
//

import UIKit

class GYWMMidCell: UICollectionViewCell {
    static let indentifier: String = "GYWMDetaiSecCell"

    var colorStr:String = "" {
        didSet {
            iconLabel.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: colorStr)
        }
    }
    
    var valuedic:NSDictionary = [:] {
        didSet {
            titleLabel.text = (valuedic["stove_name"] as! String)
            valueLabel.text = (valuedic["value"] as! String)
        }
    }
    
    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var valueLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.textAlignment = .center
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

extension GYWMMidCell {
    func setupViews() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(iconLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
    }
    
    func addLayout() {
        iconLabel.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.width.height.equalTo(8)
            make.centerY.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(17)
            make.width.equalTo(110)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
            make.height.equalTo(25)
        }
    }
}
