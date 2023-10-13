//
//  GYWTDDataHeaderView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit

class GYWTDDataBaseHeaderView: UICollectionReusableView {
    static let indentifier: String = "GYWTDDataBaseHeaderView"
    
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
        
        self.addSubview(linelabel)
    }
    func addLayout() {
        linelabel.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.bottom.equalTo(0)
            make.width.equalTo(1)
        }
    }
}
