//
//  GYWTDDataBaseCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/26.
//

import UIKit

class GYWTDDataBaseCell: UICollectionViewCell {
    static let indentifier: String = "GYWTDDataBaseCell"
    
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 119, height: 36))
        cell.contentView.backgroundColor = .white
        // 添加自定义分割线视图
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 1))
        separatorView.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F2F2F2")
        cell.addSubview(separatorView)
        return cell
    }
}
