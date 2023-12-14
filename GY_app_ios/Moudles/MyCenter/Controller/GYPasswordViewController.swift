//
//  GYPasswordViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/25.
//

import UIKit

class GYPasswordViewController: GYViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"
        
        setupViews()
        addLayout()
    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var oldtitleLabel:UILabel = {
        let label = UILabel()
        label.text = "原密码"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var oldTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    private lazy var linelabel1:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var newtitleLabel:UILabel = {
        let label = UILabel()
        label.text = "新密码"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var newTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    private lazy var linelabel2:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var newsuretitleLabel:UILabel = {
        let label = UILabel()
        label.text = "确认新密码"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private lazy var newsureTF:UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    private lazy var sureeditBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("确认修改", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
}

extension GYPasswordViewController {
    
    @objc func btnClick() {
        if newsureTF.text == newTF.text && newTF.text != "" && oldTF.text != "" && newTF.text!.count >= 6 && newTF.text!.count <= 20{
            let passwordold = String(format: oldTF.text!).data(using: .utf8)
            let passwordnew = String(format: newTF.text!).data(using: .utf8)
            
            let params = ["user_id":GYUserBaseInfoData.default.user_id,"password_old":passwordold!.base64EncodedString(),"password_new":passwordnew!.base64EncodedString()] as [String : Any]
            GYNetworkManager.share.requestData(.post, api: Api.posteditpassword, parameters: params) { [weak self] (result) in
                guard let weakSelf = self else{
                    return
                }
                let rresult = result as! [String:Any]
                if rresult["code"] as! Int64 == 200 {
                    GYHUD.show("修改成功")
                    weakSelf.navigationController?.popViewController(animated: true)
                }else{
                    GYHUD.show(rresult["message"] as! String)
                }
               
            }
        }else {
            GYHUD.show("修改不符合要求，请调整")
        }
        
    }
    func setupViews() {
        self.view.addSubview(bgView)
        bgView.addSubview(oldtitleLabel)
        bgView.addSubview(oldTF)
        bgView.addSubview(linelabel1)
        bgView.addSubview(newtitleLabel)
        bgView.addSubview(newTF)
        bgView.addSubview(linelabel2)
        bgView.addSubview(newsuretitleLabel)
        bgView.addSubview(newsureTF)
        self.view.addSubview(sureeditBtn)
    }
    func addLayout() {
        bgView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        oldtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(16.5)
            make.left.equalTo(20)
            make.height.equalTo(21)
        }
        
        oldTF.snp.makeConstraints { make in
            make.top.equalTo(16.4)
            make.left.equalTo(127.5)
            make.right.equalTo(-15)
            make.height.equalTo(21)
        }
        
        linelabel1.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(1)
            make.top.equalTo(oldtitleLabel.snp.bottom).offset(14.5)
        }
        
        newtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(linelabel1.snp.bottom).offset(13.5)
            make.left.equalTo(20)
            make.height.equalTo(21)
        }
        
        newTF.snp.makeConstraints { make in
            make.top.equalTo(newtitleLabel)
            make.left.equalTo(127.5)
            make.right.equalTo(-15)
            make.height.equalTo(21)
        }
        
        linelabel2.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(1)
            make.top.equalTo(newtitleLabel.snp.bottom).offset(14.5)
        }
        
        newsuretitleLabel.snp.makeConstraints { make in
            make.top.equalTo(linelabel2.snp.bottom).offset(13.5)
            make.left.equalTo(20)
            make.height.equalTo(21)
        }
        
        newsureTF.snp.makeConstraints { make in
            make.top.equalTo(newsuretitleLabel)
            make.left.equalTo(127.5)
            make.right.equalTo(-15)
            make.height.equalTo(21)
            make.bottom.equalTo(-17.5)
        }
        
        sureeditBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
}
