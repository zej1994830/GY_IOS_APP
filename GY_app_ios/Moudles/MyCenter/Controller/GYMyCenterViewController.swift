//
//  GYMyCenterViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import UIKit

class GYMyCenterViewController: GYViewController{
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationSuccess(_:)), name: NotificationConstant.locationSuccess, object: nil)
        
        super.viewDidLoad()
        setupViews()
        addLayout()
        
        request()
    }
    let imageArray:NSArray = ["my_shebei","my_denglu","my_mima","my_gengxin"]
    let titleArray:NSArray = ["设备有效期","登录记录","修改密码","版本更新"]
    
    var is_invalid:Int64 = 1
    
    private lazy var bgView:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "my_bg_mine")
        return imageV
    }()
    
    private lazy var iconLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0,weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.layer.cornerRadius = 39
        label.layer.masksToBounds = true
        label.text = "朱"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.text = "朱秋柏"
        return label
    }()
    
    private lazy var companyLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "湖南湘潭钢铁集团"
        return label
    }()

    private lazy var companyImageV:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "my_company")
        return imageV
    }()
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.clear
        tableview.isScrollEnabled = false
        tableview.contentOffset = CGPointMake(0, 20)
        return tableview
    }()
    
    private lazy var logoutBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(logoutBtnClick), for: .touchUpInside)
        return btn
    }()
}

extension GYMyCenterViewController:UITableViewDelegate, UITableViewDataSource  {
    func setupViews(){
        self.view.addSubview(bgView)
        self.view.addSubview(iconLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(companyLabel)
        self.view.addSubview(companyImageV)
        self.view.addSubview(tableView)
        self.view.addSubview(logoutBtn)
        
        iconLabel.text = "\(GYUserBaseInfoData.default.user_name.first ?? " ")"
        nameLabel.text = GYUserBaseInfoData.default.user_name
        companyLabel.text = GYUserBaseInfoData.default.subordinate_unit
    }
    
    func addLayout(){
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(410)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(77.5)
            make.height.width.equalTo(78)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconLabel.snp.bottom).offset(17.5)
            make.height.equalTo(28)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
            make.top.equalTo(nameLabel.snp.bottom).offset(7.5)
        }
        
        companyImageV.snp.makeConstraints { make in
            make.right.equalTo(companyLabel.snp.left).offset(-6)
            make.height.width.equalTo(16)
            make.centerY.equalTo(companyLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(48)
            make.left.right.equalTo(0)
            make.height.equalTo(250)
        }
        
        logoutBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-48)
            make.left.equalTo(22.5)
            make.right.equalTo(-22.5)
            make.height.equalTo(49)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYMyCenterCell? = tableView.dequeueReusableCell(withIdentifier: GYMyCenterCell.indentifier) as? GYMyCenterCell
        
        if cell == nil {
            cell = GYMyCenterCell(style: .default, reuseIdentifier: GYMyCenterCell.indentifier)
        }
        cell?.imageStr = imageArray[indexPath.row] as! String
        cell?.titleStr = titleArray[indexPath.row] as! String
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = GYDeviceTimeViewController()
            if is_invalid == 0 {
                vc.device = GYDeviceData.default.device_name
                vc.time = String(format: "%@至%@", GYDeviceData.default.start_time,GYDeviceData.default.end_time)
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = GYDeviceExpireViewController()
                self.zej_present(vc, vcTransitionDelegate: ZEJRollDownTransitionDelegate()) {
                    
                }
            }
            
        }else if indexPath.row == 1{
            let vc = GYLoginTimeViewController()
            vc.array = GYUserBaseInfoData.default.landing_time
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = GYPasswordViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            //版本更新
            
        }
    }
    
    func request() {
        let params = ["user_id":GYUserBaseInfoData.default.user_id,"device_id":GYDeviceData.default.id] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getdevicetime, parameters: params) { [weak self]result in
            guard let weakSelf = self else{
                return
            }
            let rresult = result as! [String:Any]
            if rresult["message"] as! String == "操作成功" {
                let rrresult = rresult["data"] as! [String:Any]
                let rrrresult = rrresult["result"] as! Int64
                let is_invalid = rrresult["is_invalid"] as! Int64
                weakSelf.is_invalid = is_invalid
            }else{
                
            }
            
        }
    }
    
    @objc func logoutBtnClick() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = GYLoginViewController()
    }
    
    @objc private func locationSuccess(_ notification: Notification){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(300)) {
            self.iconLabel.text = "\(GYUserBaseInfoData.default.user_name.first ?? " ")"
            self.nameLabel.text = GYUserBaseInfoData.default.user_name
            self.companyLabel.text = GYUserBaseInfoData.default.subordinate_unit
        }
       
    }
}
