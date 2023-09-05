//
//  GYUIViewExtension.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/9.
//

import UIKit
/// 记录自己的导航栏alpha只
extension UIViewController {
    
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "navBarAlpha".hashValue)
    }
    
    /// 导航栏透明度
    @objc public var navBarAlpha: CGFloat {
        set {
            
            if newValue > 1 {
                self.navBarAlpha = 1
            }
            
            if newValue < 0 {
                self.navBarAlpha = 0
            }
            
            
            objc_setAssociatedObject(self, GYViewController.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
            self.navigationController?.setNavigationBarAlapha(navBarAlpha)
        }
        get {
            return objc_getAssociatedObject(self, GYViewController.RuntimeKey.clickEdgeInsets!) as? CGFloat ?? 0
        }
    }
    
    /// 导航栏文字返回按钮颜色
    @objc public var navTintColor: UIColor {
        set{
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: newValue]
        }
        
        get{
            return self.navTintColor
        }
    }
}
