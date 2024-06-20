//
//  GYWTDWarnViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/19.
//

import UIKit

class GYWTDWarnViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var rightBarbtn:UIBarButtonItem? = nil
    var dataArray:NSArray = []{
        didSet{
            noDataView.isHidden = dataArray.count != 0
            noDataView.snp.remakeConstraints { make in
                make.center.size.equalTo(tableView)
            }
        }
    }
    var function_type:Int = 0
    var isrealtime:Bool = false {
        didSet{
            
        }
    }
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_rili"), for: .normal)
        btn.setTitle("2023-04-16 14:43 至 2023-04-18 14:43", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 115, bottom: 0, right: -60)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var resetBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("重置", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(resetBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.estimatedRowHeight = 27
        tableview.separatorStyle = .singleLine
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
        if isrealtime {
            headView.isHidden = true
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(topHeight + 5)
                make.left.right.bottom.equalTo(0)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
//        let startIndex = currentDateString.index(currentDateString.startIndex, offsetBy: 5)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
        
        realtimerequest()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightBarbtn = navigationItem.rightBarButtonItem!
        navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.rightBarButtonItem = rightBarbtn
    }
}


extension GYWTDWarnViewController {
    func setupViews() {
        self.title = "报警"
        self.view.addSubview(headView)
        headView.addSubview(timeBtn)
        headView.addSubview(resetBtn)
        self.view.addSubview(tableView)
    }
    
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.top.equalTo(topHeight + 5)
            make.left.right.equalTo(0)
        }
        
        resetBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.equalTo(55)
            make.height.equalTo(40)
            make.top.equalTo(4.5)
            make.bottom.equalTo(-4.5)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.top.height.bottom.equalTo(resetBtn)
            make.left.equalTo(15)
            make.right.equalTo(resetBtn.snp.left).offset(-6)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.bottom.equalTo(0)
        }
    }

    func realtimerequest() {
        GYHUD.showGif(view: self.view)

        let params = ["device_db":GYDeviceData.default.device_db,"function_type":function_type] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getListTimeData, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            weakSelf.tableView.reloadData()
        }
    }
    
    func historyrequest() {
        GYHUD.showGif(view: self.view)

        let params = ["device_db":GYDeviceData.default.device_db,"function_type":function_type,"start_time":currentLastHourDateString + ":00","end_time":currentDateString + ":00","number":500] as [String : Any]
        GYNetworkManager.share.requestData(.get, api: Api.getListHistoryData, parameters: params) {[weak self] (result) in
            guard let weakSelf = self else{
                return
            }
            GYHUD.hideHudForView(weakSelf.view)
            let dic:NSDictionary = result as! NSDictionary
            weakSelf.dataArray = dic["data"] as! NSArray
            weakSelf.tableView.reloadData()
        }
    }
    
    @objc func resetBtnClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
//        let startIndex = currentDateString.index(currentDateString.startIndex, offsetBy: 5)
        timeBtn.setTitle(currentLastHourDateString + " 至 " + currentDateString, for: .normal)
        realtimerequest()
    }
}


extension GYWTDWarnViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYWTDWarnCell? = tableView.dequeueReusableCell(withIdentifier: GYWTDWarnCell.indentifier) as? GYWTDWarnCell
        
        if cell == nil {
            cell = GYWTDWarnCell(style: .default, reuseIdentifier: GYWTDWarnCell.indentifier)
        }
        let dic:NSDictionary = dataArray[indexPath.row] as! NSDictionary
        cell?.model = GYWTDWarnDataModel.deserialize(from: dic)
        return cell!
    }
    
    @objc func timeBtnClick() {
        BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { (date1,str) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: .init(block: {
                BRDatePickerView.showDatePicker(with: .YMDHM, title: "选择时间", selectValue: nil ,isAutoSelect: false) { [weak self] (date2,str2) in
                    guard let weakSelf = self else{
                        return
                    }
                    if date1! > date2! {
                        GYHUD.show("开始时间不能大于结束时间")
                        return
                    }
//                    let startIndex = str2!.index(str2!.startIndex, offsetBy: 5)
                    weakSelf.timeBtn.setTitle(str! + " 至 " + str2!, for: .normal)
                    weakSelf.currentDateString = str2!
                    weakSelf.currentLastHourDateString = str!
                    weakSelf.historyrequest()
                }
            }))
            
        }
    }
    
    
    
}
