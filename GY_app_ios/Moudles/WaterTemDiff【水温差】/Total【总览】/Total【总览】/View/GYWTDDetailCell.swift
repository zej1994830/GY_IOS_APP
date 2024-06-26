//
//  GYWTDDetailCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/20.
//

import UIKit

class GYWTDDetailCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDDetaiSeclCell"
    
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var valueStr:Double = 0 {
        didSet{
            if titleStr == "热流(kCal/h/m²)" {
                valueLabel.text = String(format: "%.0f", valueStr)
            }
            else{
                valueLabel.text = String(format: "%.2f", valueStr)
            }
            
            if valueStr == -9999 {
                valueLabel.text = " "
            }
        }
    }
    
    var isredColor:Bool = false {
        didSet{
            if isredColor {
                valueLabel.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#FF3434")
            }else{
                valueLabel.textColor = UIColorConstant.textBlack
            }
        }
    }
    
    var isgreenColor:Bool = false {
        didSet{
            if isredColor {
                valueLabel.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#0EA10A")
            }else{
                valueLabel.textColor = UIColorConstant.textBlack
            }
        }
    }
   
    var isyellowColor:Bool = false {
        didSet{
            if isredColor {
                valueLabel.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#F88A05")
            }else{
                valueLabel.textColor = UIColorConstant.textBlack
            }
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "入水温度"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var valueLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.text = "41.11"
        label.sizeToFit()
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


extension GYWTDDetailCell {
    func setupViews() {
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.right.equalTo(0)
            make.width.equalTo((APP.WIDTH - 3) / 3)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(12)
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(-20)
        }
    }
}
