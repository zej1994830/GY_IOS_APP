//
//  GYMainViewCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/4.
//

import UIKit

class GYMainViewCell: UICollectionViewCell {
    static let indentifier: String = "GYMainViewCell"
    
    var dataarray:NSArray = []{
        didSet{
            
        }
    }
    
    private lazy var midView:UIView = {
        let view = UIView()
        return view
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
        self.addSubview(midView)
        midView.addSubview(imageV)
        midView.addSubview(titleLabel)
    }
    
    private func addLayout(){
        
    }
    
    func colorlayer(color1:String , color2:String){
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor.UIColorFromHexvalue(color_vaule: color1).cgColor,UIColor.UIColorFromHexvalue(color_vaule: color2).cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        caGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: rellySizeForiPhoneWidth(167.5, 95).width, height: rellySizeForiPhoneWidth(167.5, 95).height)
        self.layer.insertSublayer(caGradientLayer, at: 0)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
