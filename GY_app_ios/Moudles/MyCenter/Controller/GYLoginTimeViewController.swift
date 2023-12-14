//
//  GYLoginTimeViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/25.
//

import UIKit

class GYLoginTimeViewController: GYViewController {

    var array:NSArray = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        
        // Do any additional setup after loading the view.
        self.title = "登录记录"
        
        
    }
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
//        tableview.contentOffset = CGPointMake(0, 20)
        return tableview
        
    }()

}

extension GYLoginTimeViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count == 0 ? 10 : array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYLoginTimeCell? = tableView.dequeueReusableCell(withIdentifier: "GYLoginTimeCell") as? GYLoginTimeCell
        
        if cell == nil {
            cell = GYLoginTimeCell(style: .default, reuseIdentifier: "GYLoginTimeCell")
        }
        if array.count != 0 {
            cell?.timeStr = array[indexPath.row] as! String
        }
//        cell?.timeStr = array[indexPath.row] as! String
        return cell ?? UITableViewCell()
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
    }
    
    func addLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 10)
            make.right.left.bottom.equalTo(0)
        }
        
    }
    
}
