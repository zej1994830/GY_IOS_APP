//
//  GYWMDetaiSecCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2024/5/31.
//

import UIKit

class GYWMDetaiSecCell: UICollectionViewCell {
    static let indentifier: String = "GYWMDetaiSecCell"
    
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
    
    var value3Str:String = "" {
        didSet{
            value3Label.text = value3Str
        }
    }
    
    var value4Str:String = "" {
        didSet{
            value4Label.text = value4Str
        }
    }
    
    var value5Str:String = "" {
        didSet{
            value5Label.text = value5Str
        }
    }
    
    var value6Str:String = "" {
        didSet{
            value6Label.text = value6Str
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
    
    private lazy var value3Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var value4Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var value5Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var value6Label:UILabel = {
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

extension GYWMDetaiSecCell {
    func setupViews() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        self.contentView.addSubview(value2Label)
        self.contentView.addSubview(value3Label)
        self.contentView.addSubview(value4Label)
        self.contentView.addSubview(value5Label)
        self.contentView.addSubview(value6Label)
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(26.5)
            make.width.equalTo(APP.WIDTH - 53)
            make.right.equalTo(-26.5)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(18)
            make.left.equalTo(titleLabel)
        }
        
        value2Label.snp.makeConstraints { make in
            make.left.equalTo(APP.WIDTH - 159)
            make.centerY.equalTo(valueLabel)
        }
        
        value3Label.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp_bottomMargin).offset(18)
            make.left.equalTo(valueLabel)
        }
        
        value4Label.snp.makeConstraints { make in
            make.left.equalTo(APP.WIDTH - 159)
            make.centerY.equalTo(value3Label)
        }
        
        value5Label.snp.makeConstraints { make in
            make.top.equalTo(value3Label.snp_bottomMargin).offset(18)
            make.left.equalTo(value3Label)
            make.bottom.equalTo(-16)
        }
        
        value6Label.snp.makeConstraints { make in
            make.left.equalTo(APP.WIDTH - 159)
            make.centerY.equalTo(value5Label)
        }
    }
}
