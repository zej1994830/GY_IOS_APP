//
//  GYETErosionMorphologyCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/12/11.
//

import UIKit

class GYETErosionMorphologyCell: UICollectionViewCell {
    static let indentifier: String = "GYETErosionMorphologyCell"
    
    var dataArray:NSArray = ["",""]{
        didSet{
            bgImageV.image = UIImage(named: dataArray[0] as! String)
            titleLabel.text = dataArray[1] as? String
        }
    }
    
    private lazy var bgImageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "ic_zonglan")
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "总览"
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

extension GYETErosionMorphologyCell {
    func setupViews(){
        self.contentView.addSubview(bgImageV)
        self.contentView.addSubview(titleLabel)
    }
    
    func addLayout(){
        bgImageV.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.height.width.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(bgImageV)
            make.height.equalTo(21)
            make.top.equalTo(bgImageV.snp.bottom).offset(10)
        }
    }
}
