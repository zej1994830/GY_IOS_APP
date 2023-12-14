//
//  GYFSBarChartButton.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/11/13.
//

import UIKit

class GYFSBarChartButton: UIButton {
    override var isSelected: Bool {
        didSet{
            setSelectedStyle()
        }
    }
    
    private var headlabel:UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#333333").cgColor
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        return label
    }()
    
    var bottomlabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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

extension GYFSBarChartButton {
    func setupViews() {
        self.addSubview(headlabel)
        self.addSubview(bottomlabel)
    }
    
    func addLayout() {
        headlabel.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalTo(0)
            make.left.equalTo(4)
            make.right.equalTo(-4)
        }
        
        bottomlabel.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.bottom.equalTo(0)
            make.top.equalTo(headlabel.snp.bottom).offset(4)
            make.left.right.equalTo(0)
        }
        
    }
    
    func setSelectedStyle() {
        if isSelected {
            headlabel.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        }else{
            headlabel.backgroundColor = .white
        }
    }
}
