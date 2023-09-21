//
//  UIButton+Extension.swift
//  CottiChannelApp
//
//  Created by zhaoenjia on 2023/6/13.
//

import UIKit
import SnapKit
class UIButton_Extension: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class ZQButton:UIButton{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let zqmargin:CGFloat = -10
        let clickArea = bounds.insetBy(dx: zqmargin, dy: zqmargin)
        return clickArea.contains(point)
    }
}
extension UIButton {
    func adjustToFitText() {
        guard let titleLabel = self.titleLabel, let text = titleLabel.text else {
            return
        }
        
        let contentInsets = self.contentEdgeInsets
        let textInsets = self.titleEdgeInsets
        
        let maxSize = CGSize(width: self.bounds.width - (contentInsets.left + contentInsets.right), height: CGFloat.greatestFiniteMagnitude)
        let textSize = text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: titleLabel.font], context: nil).size

        let buttonSize = CGSize(width: textSize.width + textInsets.left + textInsets.right, height: textSize.height + textInsets.top + textInsets.bottom)
        self.frame.size = buttonSize
        self.snp.updateConstraints({ make in
            make.width.equalTo(buttonSize.width)
        })
    }
}
