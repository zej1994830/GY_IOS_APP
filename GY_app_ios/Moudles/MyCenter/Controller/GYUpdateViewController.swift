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
    
    lazy var versionLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var updateLabel:UILabel = {
        let label = UILabel()
        label.text = "请尽快更新新版本,点击立即更新，将跳转到App Store"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var noupdateBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("暂不更新", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        btn.addTarget(self, action: #selector(noupdateBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var updateBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("立即更新", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(updateBtnClick), for: .touchUpInside)
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
    
    @objc func noupdateBtnClick() {
        self.dismiss(animated: true)
    }
    
    @objc func updateBtnClick() {
        let appId = "yourAppIdHere"
            let appStoreURL = URL(string: "https://apps.apple.com/cn/app/%E5%A4%A7%E8%BF%9E%E5%9B%BD%E4%B8%9A/id6498993795")!
            
            UIApplication.shared.open(appStoreURL, options: [:]) { (success) in
                if !success {
                    GYHUD.show("跳转失败，正在修复")
                }
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
}
