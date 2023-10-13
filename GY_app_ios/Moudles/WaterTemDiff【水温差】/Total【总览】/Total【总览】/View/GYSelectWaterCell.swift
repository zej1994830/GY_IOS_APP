//
//  GYSelectWaterCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/14.
//

import UIKit

class GYSelectWaterCell: UITableViewCell {
    var ClickBlock: ((String,Bool)->())? = nil
    
    static let indentifier: String = "GYSelectWaterCell"
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var iselectAll:Bool = false {
        didSet{
            valueswitch.isOn = iselectAll
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "一段进水"
        return label
    }()
    
    private lazy var valueswitch:UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.onTintColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        sw.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GYSelectWaterCell {
    func setupViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueswitch)
    }
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.height.equalTo(22.5)
            make.centerY.equalToSuperview()
        }
        
        valueswitch.snp.makeConstraints { make in
            make.right.equalTo(-22.5)
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.centerY.equalToSuperview().offset(-4)
        }
    }
    
    @objc func switchClick() {
        if let block = ClickBlock {
            block(titleStr,valueswitch.isOn)
        }
    }
}
