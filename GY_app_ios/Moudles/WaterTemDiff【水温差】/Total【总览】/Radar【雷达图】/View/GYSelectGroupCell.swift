//
//  GYSelectGroupCell.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/10/17.
//

import UIKit

class GYSelectGroupCell: UITableViewCell {
    var ClickBlock: ((String,Bool)->())? = nil
    
    static let indentifier: String = "GYSelectGroupCell"
    var titleStr:String = "" {
        didSet{
            titleLabel.text = titleStr
        }
    }
    
    var iselectAll:Bool = false {
        didSet{
            selectBtn.isSelected = iselectAll
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "一段进水"
        return label
    }()
    
    private lazy var selectBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "ic_select"), for: .selected)
        btn.setImage(UIImage(named: "ic_select_nor"), for: .normal)
        btn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
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
extension GYSelectGroupCell {
    func setupViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(selectBtn)
    }
    func addLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.height.equalTo(22.5)
            make.centerY.equalToSuperview()
        }
        
        selectBtn.snp.makeConstraints { make in
            make.right.equalTo(-35)
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func selectBtnClick() {
        selectBtn.isSelected = !selectBtn.isSelected
        if let block = ClickBlock {
            block(titleStr,selectBtn.isSelected)
        }
    }
}
