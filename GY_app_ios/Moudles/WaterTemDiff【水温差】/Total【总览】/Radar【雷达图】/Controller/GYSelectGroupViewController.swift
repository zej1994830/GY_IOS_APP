//
//  GYSelectGroupViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/17.
//

import UIKit
import HandyJSON

class GYSelectGroupViewController: ZEJBottomPresentViewController {
    var ClickBlock: ((NSMutableArray)->())? = nil
    
    //源数组
    var dataArray:NSMutableArray = [] {
        didSet{
    
        }
    }
    
    //缓存
    var tempArray:NSMutableArray = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var isSelectAll:Bool = true {
        didSet{
            if isSelectAll {
                tableView.reloadData()
            }
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
    
    private lazy var selectBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("全选", for: .normal)
        btn.setTitleColor(UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8"), for: .normal)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8").cgColor
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.separatorStyle = .singleLine
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

extension GYSelectGroupViewController {
    func setupViews() {
        self.view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectBtn)
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
        
        selectBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-20)
            make.width.equalTo(56)
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
    
    
}
extension GYSelectGroupViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count != 0 ? dataArray.count : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYSelectGroupCell? = tableView.dequeueReusableCell(withIdentifier: GYSelectGroupCell.indentifier) as? GYSelectGroupCell
        
        if cell == nil {
            cell = GYSelectGroupCell(style: .default, reuseIdentifier: GYSelectGroupCell.indentifier)
        }
        if dataArray.count != 0 {
//            let dic:NSDictionary = dataArray[indexPath.row] as! NSDictionary
            let dataModel = GYWTDDataModel.deserialize(from: dataArray[indexPath.row] as? NSDictionary)
            
            cell?.titleStr = (dataModel?.name)!
            //判断一下临时和源数组，找出上次的选中状态
            for temp in tempArray {
                let tempmodel = GYWTDDataModel.deserialize(from: (temp as! NSDictionary))
                if dataModel?.name == tempmodel?.name{
                    cell?.iselectAll = true
                    break
                }else{
                    cell?.iselectAll = false
                }
            }
        }
        
        cell?.ClickBlock = { [weak self] (sectionname,isON) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.changedataarray(name: sectionname, isOn: isON)
        }
        return cell ?? UITableViewCell()
    }
}

extension GYSelectGroupViewController {
    @objc func selectBtnClick() {
        isSelectAll = true
        tempArray = NSMutableArray(array: dataArray)
        tableView.reloadData()
    }
    
    @objc func cancelBtnClick() {
        self.dismiss(animated: true)
    }
    
    @objc func sureBtnClick() {
        if let block = ClickBlock {
            block(tempArray)
        }
        self.dismiss(animated: true)
    }
    
    @objc func cancel2BtnClick() {

    }
    
    func changedataarray(name:String,isOn:Bool) {
        //根据名字直接从缓存数组里增删
        if isOn {
            for temp in dataArray {
                let dic:NSDictionary = temp as! NSDictionary
                if name == (dic["name"] as! String){
                    tempArray.add(temp)
                }
            }
        }else{
            for temp in dataArray {
                let dic:NSDictionary = temp as! NSDictionary
                if name == (dic["name"] as! String){
                    tempArray.remove(temp)
                }
            }
        }
    }
    
}
