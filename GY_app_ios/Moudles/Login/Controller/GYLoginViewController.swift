//
//  GYLoginViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/23.
//

import UIKit

class GYLoginViewController: GYViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        
        self.isHiddenBgView = true
    }
    
    private lazy var titleImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "login_head")
        return imageview
    }()

    private lazy var titleLable:UILabel = {
        let label = UILabel()
        label.text = "大连国业高炉侵蚀监测系统"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColorConstant.textBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var phoneView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var phoneImageV:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "login_ic_phone")
        return imageview
    }()
    
    private lazy var phoneTextfield:UITextField = {
        let tf = UITextField()
        tf.placeholder = "手机号/账号"
        tf.font = UIFont.systemFont(ofSize: 16.0)
        tf.text = UserDefaults.standard.object(forKey: "user_account") as? String
        return tf
    }()
    
    private lazy var passwordView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var passwordImageV:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "login_ic_yanzheng")
        return imageview
    }()
    
    private lazy var passwordTextfield:UITextField = {
        let tf = UITextField()
        tf.placeholder = "密码"
        tf.font = UIFont.systemFont(ofSize: 16.0)
        tf.isSecureTextEntry = true
        tf.text = UserDefaults.standard.object(forKey: "password")  as? String
        return tf
    }()
    
    private lazy var submitBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("立即登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(submitClick), for: .touchUpInside)
        return btn
    }()
    
    
    
    
}

extension GYLoginViewController {
    func setupViews(){
        self.view.addSubview(titleImageView)
        self.view.addSubview(titleLable)
        self.view.addSubview(phoneView)
        phoneView.addSubview(phoneImageV)
        phoneView.addSubview(phoneTextfield)
        self.view.addSubview(passwordView)
        passwordView.addSubview(passwordImageV)
        passwordView.addSubview(passwordTextfield)
        self.view.addSubview(submitBtn)
        
        //径向渐变的效果尝试
//        let view = UIView(frame: CGRect(x: 0, y: 100, width: 200, height: 200))
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.frame
//        gradientLayer.colors = [UIColor.white.cgColor,UIColor.yellow.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        gradientLayer.type = .radial
//        gradientLayer.locations = [0.3,1]
//        gradientLayer.cornerRadius = 100
//        gradientLayer.masksToBounds = true
//        view.layer.addSublayer(gradientLayer)
//
//        self.view.addSubview(view)
    }
    
    func addLayout(){
        titleImageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(0)
        }
        
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom)
            make.left.equalTo(22.5)
            make.right.equalTo(-22.5)
        }
        
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(42.5)
            make.left.equalTo(22.5)
            make.right.equalTo(-22.5)
        }
        
        phoneImageV.snp.makeConstraints { make in
            make.top.left.equalTo(15.5)
            make.bottom.equalTo(-15.5)
            make.width.height.equalTo(18)
        }
        
        phoneTextfield.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.bottom.right.equalTo(-13)
            make.left.equalTo(phoneImageV.snp.right).offset(17)
        }
        
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(20)
            make.left.equalTo(22.5)
            make.right.equalTo(-22.5)
        }
        
        passwordImageV.snp.makeConstraints { make in
            make.top.left.equalTo(15.5)
            make.bottom.equalTo(-15.5)
            make.width.height.equalTo(18)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.bottom.right.equalTo(-13)
            make.left.equalTo(passwordImageV.snp.right).offset(17)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(24)
            make.left.equalTo(22.5)
            make.right.equalTo(-22.5)
            make.height.equalTo(49)
        }
    }
    
    @objc func submitClick(){
        
        GYHUD.showGif()
        
        let password = String(format: passwordTextfield.text!).data(using: .utf8)
            
        let params = ["user_account":phoneTextfield.text!,"password":password!.base64EncodedString()] as [String : Any]
        
        GYNetworkManager.share.requestData(.get, api: Api.getlogin,parameters: params) { [weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView()
            let rresult = result as! [String:Any]
            if rresult["message"] as! String == "操作成功" {
                let data: NSDictionary = rresult["data"] as! NSDictionary
                //存储
                let userBaseInfo = GYUserBaseInfoData.init(signData: data)
                CommonCache.cacheData(userBaseInfo, key: CacheKey.userDataInfoCacheKey)
                
                //本地存储
                UserDefaults.standard.set(weakSelf.phoneTextfield.text!, forKey: "user_account")
                UserDefaults.standard.set(weakSelf.passwordTextfield.text!, forKey: "password")
                UserDefaults.standard.synchronize()
                //通知
                NotificationCenter.default.post(name: NotificationConstant.locationSuccess, object: nil,userInfo: nil)
                weakSelf.dismiss(animated: true)
            }
        }
    }
}
