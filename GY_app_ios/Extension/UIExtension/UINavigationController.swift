//
//  UINavigationController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/9.
//

import UIKit

// 平滑过渡相关代码
extension UINavigationController {
    
    // 设置导航栏的透明度
    @objc func setNavigationBarAlapha(_ alpha: CGFloat){
        
        var subviews: [UIView] = []
        
        for subView in self.navigationBar.subviews {
            subviews.append(subView)
        }
        
        
        
        if let backgroundView = subviews.first {
            backgroundView.alpha = alpha
            
            if UIDevice.current.systemVersion < "13" {
                
                for subview in backgroundView.subviews {
                    subview.alpha = alpha
                }
                
            }
        }
    }
    
}
