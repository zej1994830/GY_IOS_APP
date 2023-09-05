//
//  GYDeviceExpireViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/31.
//

import UIKit

class GYDeviceExpireViewController: ZEJRollDownViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var iconImageV:UIImageView = {
        let imagev = UIImageView()
        imagev.image = UIImage(named: "my_deviceexpire")
        return imagev
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "当前设备已过期"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.text = String(format: "设备有效期:%@至%@", GYDeviceData.default.start_time,GYDeviceData.default.end_time)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var sureBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("知道了", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return btn
    }()

}

extension GYDeviceExpireViewController{
    func setupViews() {
        self.view.addSubview(bgView)
        bgView.addSubview(iconImageV)
        bgView.addSubview(titleLabel)
        bgView.addSubview(contentLabel)
        bgView.addSubview(sureBtn)
    }
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(231)
            make.right.equalTo(-15)
        }
        
        iconImageV.snp.makeConstraints { make in
            make.top.equalTo(23.5)
            make.width.equalTo(240.22)
            make.height.equalTo(153.02)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageV.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7.5)
            make.centerX.equalToSuperview()
        }
        
        sureBtn.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(29.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.bottom.equalTo(-25)
        }
    }
    
    @objc func sureBtnClick() {
        self.dismiss(animated: true)
    }
}
