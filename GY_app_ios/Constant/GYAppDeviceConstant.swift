//
//  GYAppDeviceConstant.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit

class GYAppDeviceConstant {
    
    
    static var window: UIWindow? {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            return app.window
        }
        return nil
    }
    
    static var topSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return GYAppDeviceConstant.window?.safeAreaInsets.top ?? 0
        } else {
            return 0
        }
    }
    
    static var navHeight: CGFloat {
        return 44 + topSafeArea
    }
    
    static var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return GYAppDeviceConstant.window?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
}
