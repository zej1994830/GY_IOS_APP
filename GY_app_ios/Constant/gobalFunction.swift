//
//  gobalFunction.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/22.
//

import Foundation
import UIKit
/// 计算真实的大小,按照比例缩放的大小
/// - Parameters:
///   - width: 原始图宽度
///   - height: 原始图高度
/// - Returns:  等比适配后真实大小
func rellySizeForWidth(_ width: CGFloat, _ height: CGFloat) -> CGSize{
    
    let rate: CGFloat = width / height
    let afterWidth: CGFloat = width * (UIScreen.main.bounds.width / 768)
    let afterHeight: CGFloat = afterWidth / rate
    
    return CGSize.init(width: afterWidth, height: afterHeight)
}

func rellySizeForiPhoneWidth(_ width: CGFloat, _ height: CGFloat) -> CGSize{
    
    let rate: CGFloat = width / height
    let afterWidth: CGFloat = width * (UIScreen.main.bounds.width / 375)
    let afterHeight: CGFloat = afterWidth / rate
    
    return CGSize.init(width: afterWidth, height: afterHeight)
}


/// 栈顶控制器
var Global_TopViewController: UIViewController? {
    let tabbarController = GYTabbarController.share
    if let navigatinController = tabbarController.selectedViewController as? UINavigationController {
        if let topviewController = navigatinController.topViewController {
            return topviewController
        }
    }
    return nil
}
