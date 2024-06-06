//
//  GYMainViewCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/4.
//

import UIKit

class GYMainViewCell: UICollectionViewCell {
    static let indentifier: String = "GYMainViewCell"
    let caGradientLayer:CAGradientLayer = CAGradientLayer()
    
    var dataarray:NSArray = []{
        didSet{
            imageV.image = UIImage(named: dataarray[0] as! String)
            titleLabel.text = dataarray[1] as? String
            colorlayer(color1: dataarray[2] as! String, color2: dataarray[3] as! String)
        }
    }
    
    private lazy var midView:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bgimageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "main_bg_kuai")
        return imagev
    }()
    
    private lazy var imageV:UIImageView = {
        let imagev = UIImageView()
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
extension GYMainViewCell {
    private func setupViews(){
        self.contentView.addSubview(bgimageV)
        self.contentView.addSubview(midView)
        midView.addSubview(titleLabel)
        midView.addSubview(imageV)
        
        self.contentView.layer.insertSublayer(caGradientLayer, at: 0)
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
    }
    
    private func addLayout(){
        bgimageV.snp.makeConstraints { make in
            make.top.equalTo(7.5)
            make.left.equalTo(43)
            make.right.equalTo(-39)
            make.bottom.equalTo(0)
        }
        
        midView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(0)
            make.height.equalTo(28)
        }
        
        imageV.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(titleLabel.snp.left).offset(-4)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }
    }
    
    func colorlayer(color1:String , color2:String){
        caGradientLayer.colors = [UIColor.UIColorFromHexvalue(color_vaule: color1).cgColor,UIColor.UIColorFromHexvalue(color_vaule: color2).cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        caGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: rellySizeForiPhoneWidth(167.5, 95).width, height: rellySizeForiPhoneWidth(167.5, 95).height)
    }
}
