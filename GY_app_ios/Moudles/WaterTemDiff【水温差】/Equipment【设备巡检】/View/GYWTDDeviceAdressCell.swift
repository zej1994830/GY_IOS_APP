//
//  GYWTDDeviceAdressCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/23.
//

import UIKit

class GYWTDDeviceAdressCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDDeviceAdressCell"
    
    var isException: Bool = true {
        didSet{
            if isException {
                iconImageV.image = UIImage(named: "ic_yichang")
                typeLabel.text = "异常"
            }else{
                iconImageV.image = UIImage(named: "ic_zhengchang")
                typeLabel.text = "正常"
            }
        }
    }
    
    var titleStr: String = "" {
        didSet{
            titleLabel.text = titleStr
            titleLabel.sizeToFit()
        }
    }
    
    private lazy var iconImageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "ic_zhengchang")
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = "J1-S-1-2"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var typeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "正常"
        label.textAlignment = .left
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


extension GYWTDDeviceAdressCell {
    func setupViews() {
        self.contentView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F8F8F8")
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE").cgColor
        self.contentView.layer.cornerRadius = 2
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(iconImageV)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(typeLabel)
    }
    
    func addLayout() {
        iconImageV.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.width.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageV)
            make.left.equalTo(iconImageV.snp.right).offset(8)
            make.width.equalTo(APP.WIDTH - 30 - 70)
            make.right.equalTo(-8)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(titleLabel)
        }
    }
}
