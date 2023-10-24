//
//  GYWTDWarnCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/19.
//

import UIKit

class GYWTDWarnCell: UITableViewCell {
    static let indentifier: String = "GYTotalWTDTVCell"
    
    var model:GYWTDWarnDataModel? = nil{
        didSet{
            titleLabel.text = model?.detail
            timeLabel.text = model?.date
            
            //0:低低报警;1:低报警;2:高报警；3:高高报警
            if model?.alarm_type == 0 {
                imageV.image = UIImage(named: "ic_didi")
            }else if model?.alarm_type == 1 {
                imageV.image = UIImage(named: "ic_di")
            }else if model?.alarm_type == 2 {
                imageV.image = UIImage(named: "ic_gao")
            }else if model?.alarm_type == 3 {
                    imageV.image = UIImage(named: "ic_gaogao")
            }else if model?.alarm_type == 4 {
                
            }else if model?.alarm_type == 5 {
                
            }else if model?.alarm_type == 6 {
                
            }
        }
    }
    
    private lazy var imageV:UIImageView = {
        let imagev = UIImageView()
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#999999")
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

extension GYWTDWarnCell {
    func setupViews() {
        self.contentView.addSubview(imageV)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
    }
    
    func addLayout() {
        imageV.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.height.width.equalTo(49)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(11)
            make.left.equalTo(imageV.snp.right).offset(14)
            make.right.equalTo(-16.5)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
}
