//
//  GYWTDDataBaseBaseCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/17.
//

import UIKit

class GYWTDDataBaseBaseCell: UITableViewCell {
    static let indentifier: String = "GYWTDDataBaseCell"
    
    var isBold:Bool = false {
        didSet{
            if isBold {
                valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            }else{
                valueLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            }
        }
    }
    
    var istitleView:Bool = false{
        didSet{
            if istitleView {
                self.contentView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EFF4FA")
            }else{
                self.contentView.backgroundColor = .white
            }
        }
    }
    
    lazy var valueLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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

extension GYWTDDataBaseBaseCell {
    func setupViews() {
        self.contentView.addSubview(valueLabel)
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        separatorView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        self.addSubview(separatorView)
    }
    
    func addLayout() {
        valueLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(0)
        }
    }
}
