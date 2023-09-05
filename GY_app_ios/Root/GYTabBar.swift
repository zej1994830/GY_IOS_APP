//
//  GYTabBar.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit

class GYTabBar: UITabBar {

    private var needLayout: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GYTabBar {
    override var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
    
    private func setupViews() {
        shadowImage = UIImage.init()
        backgroundImage = UIColor.white.createImage(CGSize.init(width: UIScreen.main.bounds.width, height: 64 + GYAppDeviceConstant.bottomSafeArea))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.height = 64 + GYAppDeviceConstant.bottomSafeArea
        self.y = UIScreen.main.bounds.height - self.height
        
        let path = CGMutablePath()
        path.addRect(bounds)
        layer.shadowPath = path
        path.closeSubpath()
        layer.shadowColor = UIColor.black.alpha(0.06).cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: -2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 1
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        layoutItems()
    }
    
    private func layoutItems() {
        
        for tabBarItem in self.subviews {
            
            if String(describing:tabBarItem.self).contains("UITabBarButton") && needLayout {
                
                for subView in tabBarItem.subviews {
                    
                    if String(describing:subView.self).contains("Label") {
                        
                        
                    }
                    
                    if String(describing:subView.self).contains("UITabBarSwappableImageView") {
                       
                        guard let view = subView as? UIImageView else {
                            return
                        }
                        //切换成GIF图
//                        let res = gifImage(gifPath: "home.gif")
//                        view.animationImages = res.0
//                        view.animationRepeatCount = 1
//                        view.animationDuration = res.1
//                        view.startAnimating()
                    }
                }
                
                
            }
        }
        needLayout = false
    }
}
