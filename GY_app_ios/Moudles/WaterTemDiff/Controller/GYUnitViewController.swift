//
//  GYUnitViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/13.
//

import UIKit

class GYUnitViewController: ZEJRollDownViewController {
    
    private lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "单位说明"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private lazy var closeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_close"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var reliuLabel:UILabel = {
        let label = UILabel()
        label.text = "热流"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var reliuUnitLabel:UILabel = {
        let label = UILabel()
        label.text = "kkC"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var wenchaLabel:UILabel = {
        let label = UILabel()
        label.text = "温差/入温/出温"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var wenchaUnitLabel:UILabel = {
        let label = UILabel()
        label.text = "°C"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var liuliangLabel:UILabel = {
        let label = UILabel()
        label.text = "流量/入流/出流"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var liuliangUnitLabel:UILabel = {
        let label = UILabel()
        label.text = "t"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var lineView:UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var line2View:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var line3View:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var knowBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("知道了", for: .normal)
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lineView.drawDashLine(strokeColor: UIColor.UIColorFromHexvalue(color_vaule: "#CCCCCC"),lineWidth: 0.5,lineLength: 4,lineSpacing: 4)
        line2View.drawDashLine(strokeColor: UIColor.UIColorFromHexvalue(color_vaule: "#CCCCCC"),lineWidth: 0.5,lineLength: 4,lineSpacing: 4)
        line3View.drawDashLine(strokeColor: UIColor.UIColorFromHexvalue(color_vaule: "#CCCCCC"),lineWidth: 0.5,lineLength: 4,lineSpacing: 4)
    }

}

extension GYUnitViewController {
    func setupViews(){
        self.view.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(closeBtn)
        bgView.addSubview(reliuLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(reliuUnitLabel)
        bgView.addSubview(wenchaLabel)
        bgView.addSubview(line2View)
        bgView.addSubview(wenchaUnitLabel)
        bgView.addSubview(liuliangLabel)
        bgView.addSubview(line3View)
        bgView.addSubview(liuliangUnitLabel)
        bgView.addSubview(knowBtn)
    }
    func addLayout(){
        bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.height.equalTo(28)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.width.height.equalTo(15)
            make.centerY.equalTo(titleLabel)
        }
        
        reliuLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.height.equalTo(21)
        }
        
        reliuUnitLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalTo(reliuLabel)
            make.height.equalTo(22.5)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(reliuLabel.snp.right).offset(8)
            make.height.equalTo(1)
            make.centerY.equalTo(reliuLabel)
            make.right.equalTo(reliuUnitLabel.snp.left).offset(-8)
        }
        
        wenchaLabel.snp.makeConstraints { make in
            make.left.equalTo(reliuLabel)
            make.top.equalTo(reliuLabel.snp.bottom).offset(20.5)
            make.height.equalTo(21)
        }
        
        wenchaUnitLabel.snp.makeConstraints { make in
            make.right.equalTo(-26)
            make.centerY.equalTo(wenchaLabel)
            make.height.equalTo(22.5)
        }
        
        line2View.snp.makeConstraints { make in
            make.left.equalTo(wenchaLabel.snp.right).offset(8)
            make.height.equalTo(1)
            make.centerY.equalTo(wenchaLabel)
            make.right.equalTo(lineView)
        }
        
        liuliangLabel.snp.makeConstraints { make in
            make.left.equalTo(wenchaLabel)
            make.top.equalTo(wenchaLabel.snp.bottom).offset(20.5)
            make.height.equalTo(21)
        }
        
        liuliangUnitLabel.snp.makeConstraints { make in
            make.right.equalTo(-26)
            make.centerY.equalTo(liuliangLabel)
            make.height.equalTo(22.5)
        }
        
        line3View.snp.makeConstraints { make in
            make.left.equalTo(liuliangLabel.snp.right).offset(8)
            make.height.equalTo(1)
            make.centerY.equalTo(liuliangLabel)
            make.right.equalTo(lineView)
        }
        
        knowBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(liuliangLabel.snp.bottom).offset(30)
            make.height.equalTo(44)
            make.bottom.equalTo(-20)
        }
    }
    
    @objc func btnClick(){
        self.dismiss(animated: true)
    }
    
}
