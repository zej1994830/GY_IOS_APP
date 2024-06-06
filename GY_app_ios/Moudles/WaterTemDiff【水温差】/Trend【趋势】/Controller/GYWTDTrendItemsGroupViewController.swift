//
//  GYWTDTrendItemsGroupViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/7.
//

import UIKit

class GYWTDTrendItemsGroupViewController: ZEJBottomPresentViewController {

    var ClickBlock: ((NSMutableArray)->())? = nil

    //3:GYTHCurveViewController
    var type:Int = 0
    //源数组
    var dataArray:NSArray = [] {
        didSet{
    
        }
    }
    
    //缓存
    var tempArray:NSMutableArray = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    private lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "组别"
        return label
    }()
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    private lazy var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F3F3F3")
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sureBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var allBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("全选", for: .normal)
        btn.setTitleColor(UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8"), for: .normal)
        btn.addTarget(self, action: #selector(allBtnClick), for: .touchUpInside)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8").cgColor
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelBtnClick))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(cancel2BtnClick))
        self.view.addGestureRecognizer(tap)
        contentView.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }

}

extension GYWTDTrendItemsGroupViewController {
    func setupViews() {
        self.view.addSubview(contentView)
        contentView.addSubview(titleLabel)
//        contentView.addSubview(allBtn)
        contentView.addSubview(tableView)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(sureBtn)
        
    }
    func addLayout() {
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(400)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(22)
            make.top.equalTo(17)
            make.height.equalTo(28)
        }
        
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(0)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-10)
        }
        
        cancelBtn.snp.makeConstraints { make in
//            make.top.equalTo(tableView.snp.bottom).offset(25)
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.height.equalTo(44)
            make.right.equalTo(sureBtn.snp.left).offset(-13)
        }
        
        sureBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.height.centerY.width.equalTo(cancelBtn)
        }
    }
    
    @objc func cancelBtnClick() {
        self.dismiss(animated: true)
    }
    
    @objc func cancel2BtnClick() {

    }
    
    @objc func sureBtnClick() {
        if tempArray.count > 5 {
            GYHUD.show("目前不让选中超过五个")
            return
        }
        
        if tempArray.count == 0 {
            GYHUD.show("必须选一个")
            return
        }
        
        if let block = ClickBlock {
            block(tempArray)
        }
        self.dismiss(animated: true)
    }
    
    @objc func allBtnClick() {

    }
}


extension GYWTDTrendItemsGroupViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count != 0 ? dataArray.count : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYWTDTrendItemsGroupCell? = tableView.dequeueReusableCell(withIdentifier: GYWTDTrendItemsGroupCell.indentifier) as? GYWTDTrendItemsGroupCell
        
        if cell == nil {
            cell = GYWTDTrendItemsGroupCell(style: .default, reuseIdentifier: GYWTDTrendItemsGroupCell.indentifier)
        }
        if let dic = dataArray[indexPath.row] as? NSDictionary {
            if type == 3 {
                cell?.titleStr = dic["stove_name"] as! String
            }else {
                cell?.titleStr = dic["name"] as! String
            }
            
            for temp in tempArray {
                let tempdic:NSDictionary = temp as! NSDictionary
                var str = ""
                if type == 3 {
                    str = tempdic["stove_name"] as! String
                }else {
                    str = tempdic["name"] as! String
                }
                
                if cell?.titleStr == str {
                    cell?.cellBtn.isSelected = true
                    break
                }else {
                    cell?.cellBtn.isSelected = false
                }
            }
            
            cell?.ClickBlock = {[weak self] isselectbool in
                guard let weakSelf = self else {
                    return
                }
                let dic:NSDictionary = weakSelf.dataArray[indexPath.row] as! NSDictionary
                if isselectbool {
                    weakSelf.tempArray.add(dic)
                }else{
                    for item in weakSelf.tempArray {
                        let tempdic:NSDictionary = item as! NSDictionary
                        if weakSelf.type == 3 {
                            if ((tempdic["stove_id"] as! String) == (dic["stove_id"] as! String)) {
                                weakSelf.tempArray.remove(tempdic)
                            }
                        }else {
                            if (tempdic["id"] as! Int64) == (dic["id"] as! Int64) {
                                weakSelf.tempArray.remove(tempdic)
                            }
                        }
                        
                    }
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    
}


