//
//  GYTotalWTDTVCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/12.
//

import UIKit

class GYTotalWTDTVCell: UITableViewCell {
    static let indentifier: String = "GYTotalWTDTVCell"
    
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var valueStr:Double = 0 {
        didSet{
            if titleStr == "热流" {
                valueLabel.text = String(format: "%.0f", valueStr)
            }
            else{
                valueLabel.text = String(format: "%.2f", valueStr)
            }
            
        }
    }
    
    var tempStr:Int64 = 0 {
        didSet{
            valueLabel.text = String(format: "%d", tempStr)
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
        label.text = "温差"
        label.textColor = UIColorConstant.textGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var valueLabel:UILabel = {
        let label = UILabel()
        label.text = "00.00"
        label.textColor = UIColorConstant.textBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
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

extension GYTotalWTDTVCell {
    func setupViews(){
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    func addLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(0).priority(.high)
            make.left.equalTo(10)
            make.height.equalTo(27)
            make.width.equalTo(100)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
    }
}
