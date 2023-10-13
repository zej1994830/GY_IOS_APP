//
//  GYTotalWTDCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/8.
//

import UIKit

class GYTotalWTDCell: UICollectionViewCell {
    static let indentifier: String = "GYTotalWTDCell"
    var dataStrArray:NSMutableArray = [] {
        didSet{
            dataArray.removeAllObjects()
            if dataStrArray.count == 0 {
                dataArray.addObjects(from: [["温差",dataModel?.wcValue],["热流",dataModel?.reFlowTagValue],["入温",dataModel?.inTagValue],["出温",dataModel?.outTagValue],["流量",dataModel?.flowTagTValue]])
            }else{
                for temp in dataStrArray {
                    let tempStr:String = temp as! String
                    if tempStr == "温差"{
                        dataArray.addObjects(from:[["温差",dataModel?.wcValue]])
                    }
                    if tempStr == "热流"{
                        dataArray.addObjects(from:[["热流",dataModel?.reFlowTagValue]])
                    }
                    if tempStr == "入温"{
                        dataArray.addObjects(from:[["入温",dataModel?.inTagValue]])
                    }
                    if tempStr == "出温"{
                        dataArray.addObjects(from:[["出温",dataModel?.outTagValue]])
                    }
                    if tempStr == "流量"{
                        dataArray.addObjects(from:[["流量",dataModel?.flowTagTValue]])
                    }
                }
            }
            
            titleLabel.text = dataModel?.name
            tableView.reloadData()
            
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(27 * dataArray.count)
            }
            
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            
            if dataModel?.flagFlowMeter == nil {
                bgView.isHidden = true
            }else{
                bgView.isHidden = false
            }
        }
    }
    var dataModel:GYWTDDataModel? = nil{
        didSet{
            
        }
    }
    var dataArray:NSMutableArray = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private lazy var bgView:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "一区(0°C)"
        label.textColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var tableView:UITableView = {
        let tableview = UITableView.init(frame: CGRect.zero, style: .plain)
        tableview.estimatedRowHeight = 27
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.clear
        tableview.isScrollEnabled = false
//        tableview.contentOffset = CGPointMake(0, 20)
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        addLayout()
        //蓝色
        colorlayer(color1: "#F8FBFF", color2: "#DBEAFF")
        //紫色
        colorlayer2(color1: "#FDF8FF", color2: "#FEDBFF")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GYTotalWTDCell {
    func setupViews(){
        self.contentView.addSubview(bgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(tableView)
    }
    func addLayout(){
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalTo(rellySizeForiPhoneWidth(172.5, 170).width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(27 * dataArray.count)
        }
    }
    
    func colorlayer(color1:String , color2:String){
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor.UIColorFromHexvalue(color_vaule: color1).cgColor,UIColor.UIColorFromHexvalue(color_vaule: color2).cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: rellySizeForiPhoneWidth(200, 170).width, height: rellySizeForiPhoneWidth(200, 170).height)
        self.contentView.layer.insertSublayer(caGradientLayer, at: 0)
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE").cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    func colorlayer2(color1:String , color2:String){
        let caGradientLayer:CAGradientLayer = CAGradientLayer()
        caGradientLayer.colors = [UIColor.UIColorFromHexvalue(color_vaule: color1).cgColor,UIColor.UIColorFromHexvalue(color_vaule: color2).cgColor]
        caGradientLayer.locations = [0, 1]
        caGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caGradientLayer.frame = CGRect(x: 0, y: 0, width: rellySizeForiPhoneWidth(200, 180).width, height: rellySizeForiPhoneWidth(200, 180).height)
        bgView.layer.insertSublayer(caGradientLayer, at: 0)
        bgView.layer.cornerRadius = 5
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE").cgColor
        bgView.layer.masksToBounds = true
    }
}

extension GYTotalWTDCell:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count == 0 ? 5 : dataArray.count
//        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:GYTotalWTDTVCell? = tableView.dequeueReusableCell(withIdentifier: GYTotalWTDTVCell.indentifier) as? GYTotalWTDTVCell
        
        if cell == nil {
            cell = GYTotalWTDTVCell(style: .default, reuseIdentifier: GYTotalWTDTVCell.indentifier)
        }
        let array:NSArray = dataArray[indexPath.row] as! NSArray
        cell?.titleStr = array.firstObject as! String
        cell?.valueStr = array.lastObject as! Double
        if (cell?.titleStr == "温差") {
            if dataModel?.wcException == 1 {
                cell?.isredColor = true
            }else if dataModel?.wcException == 3 {
                cell?.isyellowColor = true
            }else if dataModel?.wcException != 0 {
                cell?.isredColor = true
            }
        }else if (cell?.titleStr == "热流") {
            if dataModel?.rlException == 1 {
                cell?.isredColor = true
            }else if dataModel?.rlException == 3 {
                cell?.isyellowColor = true
            }else if dataModel?.rlException != 0 {
                cell?.isredColor = true
            }
            
        }else if (cell?.titleStr == "流量") {
            if dataModel?.llException == 1 {
                cell?.isredColor = true
            }else if dataModel?.llException == 3 {
                cell?.isyellowColor = true
            }else if dataModel?.llException != 0 {
                cell?.isredColor = true
            }
        }else{
            cell?.isredColor = false
        }
        
        return cell ?? UITableViewCell()
    }

    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if ((view?.isKind(of: UITableView.self)) != nil) {
            return self
        }
        return super.hitTest(point, with: event)
    }
}
