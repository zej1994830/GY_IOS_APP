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
        return label
    }()
    
    private lazy var typeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
        self.contentView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        self.contentView.addSubview(iconImageV)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(typeLabel)
    }
    
    func addLayout() {
        iconImageV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.height.width.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageV)
            make.left.equalTo(iconImageV.snp.right).offset(8)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconImageV).offset(-4)
            make.left.equalTo(titleLabel)
        }
    }
}
