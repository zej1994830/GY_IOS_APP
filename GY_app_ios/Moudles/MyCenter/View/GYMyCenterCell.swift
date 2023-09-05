//
//  MyCenterCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/24.
//

import UIKit

class GYMyCenterCell: UITableViewCell {

    static let indentifier: String = "GYMyCenterCell"
    
    var titleStr:String = ""{
        didSet{
            titlelabel.text = titleStr
        }
    }
    
    var imageStr:String = ""{
        didSet{
            imageV.image = UIImage(named: imageStr)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addLayout()
    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let bgLayer1 = CALayer()
        bgLayer1.frame = view.bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.addSublayer(bgLayer1)
        // shadowCode
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var imageV:UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    
    private lazy var titlelabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var arrowimageV:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "my_arrow")
        return imageV
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GYMyCenterCell {
    private func setupViews(){
        // 添加视图
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.contentView.addSubview(bgView)
        bgView.addSubview(imageV)
        bgView.addSubview(titlelabel)
        bgView.addSubview(arrowimageV)
    }
    
    private func addLayout(){
        bgView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(10)
            make.bottom.equalTo(0)
        }
        
        imageV.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.bottom.equalTo(-13)
            make.left.equalTo(20.5)
            make.width.height.equalTo(24)
        }
        
        titlelabel.snp.makeConstraints { make in
            make.left.equalTo(imageV.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        arrowimageV.snp.makeConstraints { make in
            make.right.equalTo(-15.5)
            make.centerY.equalToSuperview()
            make.width.equalTo(6.75)
            make.height.equalTo(12)
        }
        
        
    }
}
