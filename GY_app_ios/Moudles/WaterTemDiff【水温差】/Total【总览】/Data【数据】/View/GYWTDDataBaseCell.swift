//
//  GYWTDDataBaseCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit

class GYWTDDataBaseCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDDataBaseCell"
    var model: GYWTDDataData? = nil{
        didSet{
            tv.snp.updateConstraints { make in
                make.height.equalTo(36 * strArray.count + 36)
            }
            tv.reloadData()
        }
    }
    
    var strArray:NSMutableArray = []
    
    private lazy var tv:UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.bounces = false
        return tableview
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

extension GYWTDDataBaseCell:UITableViewDelegate,UITableViewDataSource {
    func setupViews() {
        self.contentView.addSubview(tv)
    }
    func addLayout() {
        tv.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
            make.height.equalTo(36 * strArray.count + 36)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYWTDDataBaseBaseCell? = tableView.dequeueReusableCell(withIdentifier: GYWTDDataBaseBaseCell.indentifier) as? GYWTDDataBaseBaseCell
        if cell == nil {
            cell = GYWTDDataBaseBaseCell(style: .default, reuseIdentifier: GYWTDDataBaseBaseCell.indentifier)
        }
        cell?.istitleView = false
        if indexPath.row == 0 {
            cell?.istitleView = true
            cell?.valueLabel.text = model?.stove_number
        }else if indexPath.row == 1 {
            cell?.valueLabel.text = "\(model?.wcValue ?? 1)"
        }else if indexPath.row == 2 {
            cell?.valueLabel.text = "\(model?.inTagValue ?? 1)"
        }else if indexPath.row == 3 {
            cell?.valueLabel.text = "\(model?.outTagValue ?? 1)"
        }else if indexPath.row == 4 {
            cell?.valueLabel.text = "\(model?.flowTagValue ?? 1)"
        }else if indexPath.row == 5 {
            cell?.valueLabel.text = "\(model?.reFlowTagValue ?? 1)"
        }
        return cell ?? UITableViewCell()
    }
}
