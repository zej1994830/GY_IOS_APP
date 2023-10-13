//
//  GYWTDTrendCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/25.
//

import UIKit

class GYWTDTrendCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDTrendCell"
    
    var labelStr:String = ""{
        didSet{
            btn.setTitle(String(format: "  %@  ", labelStr), for: .normal)
        }
    }
    
    lazy var btn:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.cornerRadius = 13.5
        btn.layer.masksToBounds = true
        btn.isEnabled = false
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

extension GYWTDTrendCell {
    func setupViews() {
        self.contentView.addSubview(btn)
    }
    func addLayout() {
        btn.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
            make.height.equalTo(27)
        }
    }
}
