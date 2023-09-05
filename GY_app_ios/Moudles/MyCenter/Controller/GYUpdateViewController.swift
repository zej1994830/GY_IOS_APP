//
//  GYUpdateViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/28.
//

import UIKit

class GYUpdateViewController: ZEJRollDownViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
    }
    
    private lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bgImageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "my_update")
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "发现新版本"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var versionLabel:UILabel = {
        let label = UILabel()
        label.text = "V2.0.6"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var updateLabel:UILabel = {
        let label = UILabel()
        label.text = "1.xxxxx\n\n2.xxxxxx\n\n3.xxxxxxxxx"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var noupdateBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("暂不更新", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return btn
    }()
    
    private lazy var updateBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("立即更新", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        return btn
    }()
}

extension GYUpdateViewController {
    func setupViews(){
        self.view.addSubview(contentView)
        contentView.addSubview(bgImageV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(updateLabel)
        contentView.addSubview(noupdateBtn)
        contentView.addSubview(updateBtn)
    }
    func addLayout(){
        contentView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(231)
        }
        
        bgImageV.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(21)
            make.top.equalTo(32)
            make.height.equalTo(33.5)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3.5)
            make.height.equalTo(22.5)
        }
        
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageV.snp.bottom).offset(10)
            make.left.equalTo(18)
            make.right.equalTo(-18)
        }
        
        noupdateBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(updateLabel.snp.bottom).offset(38)
            make.width.equalTo(150)
            make.height.equalTo(44)
            make.bottom.equalTo(-25)
        }
        
        updateBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.bottom.equalTo(noupdateBtn)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
}
