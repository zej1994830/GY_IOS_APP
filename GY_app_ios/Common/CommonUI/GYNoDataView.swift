//
//  GYNoDataView.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/9.
//

import UIKit
@objc protocol GYNoDataViewDataSource {
    
    /// 无数据页面中心图片
    func noDataViewImage(noDataView: GYNoDataView) -> UIImage?
    
    /// 无数据页面中心标题
    func noDataViewTitle(noDataView: GYNoDataView) -> String?
}

enum TFemptyState {
    //通用
    case common
    
}
class GYNoDataView: UIView {

    var mainstate:TFemptyState = .common{
        didSet{
            updateUI()
        }
    }
    
    weak var dataSource: GYNoDataViewDataSource? = nil{
        didSet{
            setDataSource()
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColorConstant.textGray
        label.text = "暂无相关数据"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
       
    private lazy var nodataImageV:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "ic_wushuju")
        return imageview
    }()
    
    private lazy var refreshButton:UIButton = {
        let label = UIButton()
        label.layer.borderColor = UIColorConstant.main.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 22;
        label.setTitle("刷新", for: .normal)
        label.setTitleColor(UIColorConstant.main, for: .normal)
        label.setImage(UIImage.init(named: "empty_refresh"), for: .normal)
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        addLayout()
        
        
    }
    
    private func setDataSource(){
        
        if dataSource != nil {
            titleLabel.text = dataSource?.noDataViewTitle(noDataView: self)
            nodataImageV.image = dataSource?.noDataViewImage(noDataView: self)
        }
    }
    
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show() -> Void {
        let view = GYNoDataView()
        
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(view)
       
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }

}
extension GYNoDataView {
    private func setupViews(){
        self.backgroundColor = .white
        self.addSubview(nodataImageV)
        self.addSubview(titleLabel)
//        self.addSubview(refreshButton)
    }
    
    private func addLayout(){
        nodataImageV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.size.equalTo(CGSize(width: 115, height: 85))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(nodataImageV.snp.bottom).offset(18)
        }
        
    }
    
    private func updateUI(){
        switch mainstate {
//        case .evaluation:
//            titleLabel.text = "暂无相关数据~"
//            nodataImageV.image = UIImage.init(named: "ic_wushuju")
        default:
            break
        }
    }
}
