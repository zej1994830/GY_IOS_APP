//
//  GYDeviceTimeViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/25.
//

import UIKit

class GYDeviceTimeViewController: GYViewController {

    var device:String = ""{
        didSet{
            deviceLabel.text = device
        }
    }
    
    var time:String = ""{
        didSet{
            timeLabel.text = time
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设备有效期"
        
        setupViews()
        addLayout()
        
        requestdata()
    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var deviceTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "设备名称："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var deviceLabel:UILabel = {
        let label = UILabel()
        label.text = GYDeviceData.default.device_name
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var linelabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var timeTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "有效期："
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "2021-06-21至2048-06-21"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
}

extension GYDeviceTimeViewController {
    
    func setupViews() {
        self.view.addSubview(bgView)
        bgView.addSubview(deviceTitleLabel)
        bgView.addSubview(deviceLabel)
        bgView.addSubview(linelabel)
        bgView.addSubview(timeTitleLabel)
        bgView.addSubview(timeLabel)
    }
    
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 10)
            make.left.right.equalTo(0)
        }
        
        deviceTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(16.5)
            make.height.equalTo(21)
        }
        
        deviceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(deviceTitleLabel)
            make.right.equalTo(-20)
        }
        
        linelabel.snp.makeConstraints { make in
            make.top.equalTo(deviceTitleLabel.snp.bottom).offset(11.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(1)
        }
        
        timeTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(linelabel.snp.bottom).offset(16.5)
            make.bottom.equalTo(-11.5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeTitleLabel)
            make.right.equalTo(-20)
        }
    }
    
    func requestdata() {
        
    }
}
