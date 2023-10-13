//
//  GYWTDDetaiSeclCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/20.
//

import UIKit

class GYWTDDetaiSecCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDDetaiSecCell"
    
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var valueStr:String = "" {
        didSet{
            valueLabel.text = valueStr
        }
    }
    
    var value2Str:String = "" {
        didSet{
            value2Label.text = value2Str
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        return label
    }()
    
    private lazy var valueLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var value2Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
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

extension GYWTDDetaiSecCell {
    func setupViews() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        self.contentView.addSubview(value2Label)
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(26.5)
            make.width.equalTo(100)
            make.right.equalTo(-rellySizeForiPhoneWidth(375 - 127.5, 10).width)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(18)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-16)
        }
        
        value2Label.snp.makeConstraints { make in
            make.left.equalTo(APP.WIDTH - 159)
            make.centerY.equalTo(valueLabel)
        }
    }
}
