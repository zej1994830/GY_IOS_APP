//
//  GYLoginTimeCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/25.
//

import UIKit

class GYLoginTimeCell: UITableViewCell {

    var timeStr:String = ""{
        didSet{
            titleLabel.text = timeStr
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addLayout()
    }

    private lazy var imageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "my_jilu")
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "2023-06-19 09:18"
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state   my_jilu
    }

}

extension GYLoginTimeCell{
    func setupViews(){
        self.contentView.addSubview(imageV)
        self.contentView.addSubview(titleLabel)
    }
    
    func addLayout(){
        imageV.snp.makeConstraints { make in
            make.left.equalTo(21.5)
            make.top.equalTo(14)
            make.height.width.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageV.snp.right).offset(15)
            make.right.equalTo(-15)
        }
    }
}
