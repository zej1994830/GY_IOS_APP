//
//  GYSelectWTDViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/14.
//

import UIKit

class GYSelectWTDViewController: ZEJRollDownViewController {
    //源数组
    var datatypeArray:NSMutableArray = []{
        didSet{
            for temp in datatypeArray {
                let str:String = temp as! String
                if str == "温差"{
                    wenchaBtn.isSelected = true
                }
                if str == "入温"{
                    ruwenBtn.isSelected = true
                }
                if str == "出温"{
                    chuwenBtn.isSelected = true
                }
                if str == "流量"{
                    liuliangBtn.isSelected = true
                }
                if str == "热流"{
                    reliuBtn.isSelected = true
                }
            }
        }
    }
    //缓存
    var typeArray:NSMutableArray = []
    var ClickBlock: ((NSMutableArray)->())? = nil
    
    var view_origin_y:CGFloat = 0{
        didSet{
            
        }
    }
    
    private lazy var bgView:UIView = {
        //箭头
        let arrowView = UIView()
        arrowView.backgroundColor = .white
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: APP.WIDTH - 85, y: 0))
        path.addLine(to: CGPoint(x: APP.WIDTH - 70, y: -15))
        path.addLine(to: CGPoint(x: APP.WIDTH - 55, y: 0))
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        arrowView.layer.addSublayer(layer)
        return arrowView
    }()
    
    private lazy var wenchaLabel:UILabel = {
        let label = UILabel()
        label.text = "温差"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var wenchaBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var ruwenLabel:UILabel = {
        let label = UILabel()
        label.text = "入温"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var ruwenBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var chuwenLabel:UILabel = {
        let label = UILabel()
        label.text = "出温"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var chuwenBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var liuliangLabel:UILabel = {
        let label = UILabel()
        label.text = "流量"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var liuliangBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.tag = 104
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var reliuLabel:UILabel = {
        let label = UILabel()
        label.text = "热流"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var reliuBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.tag = 105
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lineLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var line2Label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var line3Label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var line4Label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var line5Label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#EEEEEE")
        return label
    }()
    
    private lazy var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#F3F3F3")
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColorConstant.textBlack, for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sureBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addLayout()
    }

}

extension GYSelectWTDViewController{
    func setupViews(){
        self.view.addSubview(bgView)
        bgView.addSubview(wenchaLabel)
        bgView.addSubview(wenchaBtn)
        bgView.addSubview(ruwenBtn)
        bgView.addSubview(ruwenLabel)
        bgView.addSubview(chuwenBtn)
        bgView.addSubview(chuwenLabel)
        bgView.addSubview(liuliangBtn)
        bgView.addSubview(liuliangLabel)
        bgView.addSubview(reliuBtn)
        bgView.addSubview(reliuLabel)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        bgView.addSubview(lineLabel)
        bgView.addSubview(line2Label)
        bgView.addSubview(line3Label)
        bgView.addSubview(line4Label)
        bgView.addSubview(line5Label)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelBtnClick))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(cancel2BtnClick))
        self.view.addGestureRecognizer(tap)
        bgView.addGestureRecognizer(tap2)
        
    }
    func addLayout(){
        bgView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(view_origin_y + 70)
        }
        
        wenchaBtn.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.top.equalTo(30)
            make.height.width.equalTo(18)
        }
        
        wenchaLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.height.equalTo(22.5)
            make.centerY.equalTo(wenchaBtn)
        }
        
        ruwenBtn.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.top.equalTo(wenchaBtn.snp.bottom).offset(24)
            make.height.width.equalTo(18)
        }
        
        ruwenLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.height.equalTo(22.5)
            make.centerY.equalTo(ruwenBtn)
        }
        
        chuwenBtn.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.top.equalTo(ruwenBtn.snp.bottom).offset(24)
            make.height.width.equalTo(18)
        }
        
        chuwenLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.height.equalTo(22.5)
            make.centerY.equalTo(chuwenBtn)
        }
        
        liuliangBtn.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.top.equalTo(chuwenBtn.snp.bottom).offset(24)
            make.height.width.equalTo(18)
        }
        
        liuliangLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.height.equalTo(22.5)
            make.centerY.equalTo(liuliangBtn)
        }
        
        reliuBtn.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.top.equalTo(liuliangBtn.snp.bottom).offset(24)
            make.height.width.equalTo(18)
        }
        
        reliuLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.height.equalTo(22.5)
            make.centerY.equalTo(reliuBtn)
        }
        
        lineLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(wenchaLabel.snp.bottom).offset(13)
        }
        
        line2Label.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(ruwenLabel.snp.bottom).offset(13)
        }
        
        line3Label.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(chuwenLabel.snp.bottom).offset(13)
        }
        
        line4Label.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(liuliangLabel.snp.bottom).offset(13)
        }
        
        line5Label.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(reliuLabel.snp.bottom).offset(13)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(line5Label.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.bottom.equalTo(-14.5)
            make.height.equalTo(44)
            make.right.equalTo(sureBtn.snp.left).offset(-13)
        }
        
        sureBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.height.centerY.width.equalTo(cancelBtn)
        }
    }
}
extension GYSelectWTDViewController {
    @objc func btnClick(_ button:ZQButton) {
        button.isSelected = !button.isSelected
    }
    
    @objc func cancelBtnClick() {
        self.dismiss(animated: true)
    }
    
    @objc func cancel2BtnClick() {

    }
    
    @objc func sureBtnClick() {
        //不用数组增减了，直接判断五个Button状态
        if wenchaBtn.isSelected {
            typeArray.add("温差")
        }
        if ruwenBtn.isSelected {
            typeArray.add("入温")
        }
        if chuwenBtn.isSelected {
            typeArray.add("出温")
        }
        if liuliangBtn.isSelected {
            typeArray.add("流量")
        }
        if reliuBtn.isSelected {
            typeArray.add("热流")
        }
        
        if let block = ClickBlock {
            block(typeArray)
        }
        self.dismiss(animated: true)
    }
}
