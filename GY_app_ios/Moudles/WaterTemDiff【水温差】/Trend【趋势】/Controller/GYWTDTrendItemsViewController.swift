//
//  GYWTDTrendItemsViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/7.
//

import UIKit
import DGCharts

class GYWTDTrendItemsViewController: GYViewController {
    var currentDateString:String = ""
    var currentLastHourDateString:String = ""
    var model:GYWTDDataModel = GYWTDDataModel()
    var timeArray:[String] = ["5分钟","15分钟","30分钟","1小时","2小时","8小时","16小时","1天","7天","15天","1个月"]
    
    private lazy var headView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = "段名："
        return label
    }()
    
    private lazy var pinlvLabel:UILabel = {
        let label = UILabel()
        label.text = "频率："
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间："
        return label
    }()
    
    private lazy var groupLabel:UILabel = {
        let label = UILabel()
        label.text = "组别："
        return label
    }()
    
    private lazy var nameBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("一进一出", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nameBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var pinlvBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("分钟", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: -30)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 5)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(pinlvBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var timeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_rili"), for: .normal)
        btn.setTitle("2023-04-16 14:43 至 04-18 14:43", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 110, bottom: 0, right: -50)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 325 - APP.WIDTH, bottom: 0, right: 10)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(timeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var groupBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_arrow_blue"), for: .normal)
        btn.setTitle("C1-1、C1-2、C1-3、C1-4、C1-5", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#DDDDDD").cgColor
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: APP.WIDTH - 110, bottom: 0, right: -50)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 285 - APP.WIDTH, bottom: 0, right: 15)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(groupBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - 中视图
    private lazy var midView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        view.alpha = 0.15
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var midtimeLabel:UILabel = {
        let label = UILabel()
        label.text = "时间：2022-04-19 10:36"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var showGroupView:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#BC7DFC")
        view.label2.text = "C1-1"
        view.label3.text = "0.07"
        return view
    }()
    
    private lazy var showGroupView2:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#12B48D")
        view.label2.text = "C1-2"
        view.label3.text = "40.97"
        return view
    }()
    
    private lazy var showGroupView3:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F5C105")
        view.label2.text = "C1-3"
        view.label3.text = "41.03"
        return view
    }()
    
    private lazy var showGroupView4:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#0182F9")
        view.label2.text = "C1-4"
        view.label3.text = "27.98"
        return view
    }()
    
    private lazy var showGroupView5:showView = {
        let view = showView()
        view.label1.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#FF6E66")
        view.label2.text = "C1-5"
        view.label3.text = "5"
        return view
    }()
    
    private lazy var lineView:LineChartView = {
        let view = LineChartView()
        view.delegate = self
        //设置交互样式
        view.scaleXEnabled = true //允取消X轴缩放
        view.scaleYEnabled = true //取消Y轴缩放
        view.doubleTapToZoomEnabled = true //双击缩放
        return view
    }()
    
    private lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = rellySizeForiPhoneWidth(60, 27.5)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 6.5)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(GYWTDTrendCell.classForCoder(), forCellWithReuseIdentifier: GYWTDTrendCell.indentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
    }
    

}

extension GYWTDTrendItemsViewController {
    func setupViews() {
        self.view.addSubview(headView)
        headView.addSubview(nameLabel)
        headView.addSubview(nameBtn)
        headView.addSubview(pinlvLabel)
        headView.addSubview(pinlvBtn)
        headView.addSubview(timeLabel)
        headView.addSubview(timeBtn)
        headView.addSubview(groupLabel)
        headView.addSubview(groupBtn)
        
        self.view.addSubview(midView)
        midView.addSubview(bgView)
        midView.addSubview(midtimeLabel)
        midView.addSubview(showGroupView)
        midView.addSubview(showGroupView2)
        midView.addSubview(showGroupView3)
        midView.addSubview(showGroupView4)
        midView.addSubview(showGroupView5)
        midView.addSubview(lineView)
        midView.addSubview(collectionV)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm" // 根据需要设置日期时间格式
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm" // 根据需要设置日期时间格式
        let currentDate = Date()
        //当前时间
        currentDateString = dateFormatter.string(from: currentDate)
        //当前时间的上一个小时
        let calendar = Calendar.current
        currentLastHourDateString = dateFormatter2.string(from: calendar.date(byAdding: .hour, value: -1, to: currentDate)!)
        
        timeBtn.setTitle(String(format: "%@ 至 %@", currentLastHourDateString,currentDateString), for: .normal)
    }
    func addLayout() {
        headView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(topHeight + 5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        nameBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(105)
            make.left.equalTo(nameLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        pinlvLabel.snp.makeConstraints { make in
            make.left.equalTo(nameBtn.snp.right).offset(49)
            make.top.equalTo(21)
            make.height.equalTo(21)
        }
        
        pinlvBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(70)
            make.left.equalTo(pinlvLabel.snp_rightMargin).offset(10)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.height.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(36.5)
        }
        
        timeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
            make.left.equalTo(timeLabel.snp_rightMargin).offset(10)
        }
        
        groupLabel.snp.makeConstraints { make in
            make.left.height.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(36.5)
        }
        
        groupBtn.snp.makeConstraints { make in
            make.centerY.equalTo(groupLabel)
            make.height.equalTo(40)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12.5)
            make.left.equalTo(groupLabel.snp_rightMargin).offset(10)
        }
        
        midView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(headView.snp.bottom).offset(5)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(100)
        }
        
        midtimeLabel.snp.makeConstraints { make in
            make.left.equalTo(15.5)
            make.top.equalTo(20)
        }
        
        let arr = [showGroupView,showGroupView2,showGroupView3,showGroupView4,showGroupView5]
//        arr.snp.distributeViewsAlong(axisType:.horizontal,fixedSpacing: 24,leadSpacing: 24,tailSpacing: 24)
        arr.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 45,leadSpacing: 24,tailSpacing: 24)
        arr.snp.makeConstraints { make in
            make.top.equalTo(midtimeLabel.snp.bottom).offset(11)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.bottom.equalTo(-115)
        }
        
        collectionV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
    }
    
    @objc func nameBtnClick() {
        
    }
    
    @objc func pinlvBtnClick() {
        
    }
    
    @objc func timeBtnClick() {
        
    }
    
    @objc func groupBtnClick() {
        let vc = GYWTDTrendItemsGroupViewController()
        self.zej_present(vc, vcTransitionDelegate: ZEJBottomPresentTransitionDelegate()){
            
        }
    }
}


extension GYWTDTrendItemsViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:GYWTDTrendCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GYWTDTrendCell.indentifier, for: indexPath) as? GYWTDTrendCell
        
        if cell == nil {
            cell = GYWTDTrendCell()
        }
        cell?.labelStr = timeArray[indexPath.row]
        return cell!
    }
}

extension GYWTDTrendItemsViewController:ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func datareturnLineChartDataSet(color:String,name:String) -> LineChartDataSet {
        var dataEntries = [ChartDataEntry]()
        for i in 0..<30 {
            let y = arc4random()%1000
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        let wenchaDataSet = LineChartDataSet(entries: dataEntries, label: name)
        wenchaDataSet.colors = [UIColor.UIColorFromHexvalue(color_vaule: color)]
        wenchaDataSet.lineWidth = 2
        wenchaDataSet.circleColors = [UIColor.UIColorFromHexvalue(color_vaule: color)]
        wenchaDataSet.drawCirclesEnabled = false //不绘制转折点
        return wenchaDataSet
    }
}
