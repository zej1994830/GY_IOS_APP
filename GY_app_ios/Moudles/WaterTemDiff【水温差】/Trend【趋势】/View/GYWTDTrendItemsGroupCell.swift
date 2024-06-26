//
//  GYWTDTrendItemsGroupCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/7.
//

import UIKit

class GYWTDTrendItemsGroupCell: UITableViewCell {
    static let indentifier: String = "GYWTDTrendItemsGroupCell"
    var ClickBlock: ((Bool)->())? = nil
    
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "C1-1"
        return label
    }()
    
    lazy var cellBtn:ZQButton = {
        let btn = ZQButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension GYWTDTrendItemsGroupCell {
    func setupViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(cellBtn)
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(25.5)
        }
        
        cellBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-35)
            make.width.height.equalTo(18)
        }
    }
    
    @objc func btnClick(_ button:ZQButton) {
        button.isSelected = !button.isSelected
        if let block = ClickBlock {
            block(button.isSelected)
        }
    }
}
