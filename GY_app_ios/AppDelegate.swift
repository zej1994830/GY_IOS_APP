//
//  AppDelegate.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/7/24.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var allowRotation: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = GYTabbarController.share
        
        self.window?.makeKeyAndVisible()
        
//        if (GYUserBaseInfoData.default.user_id == 0){
            let loginVC = GYLoginViewController()
//            let loginVC = TESTViewController()
            loginVC.modalPresentationStyle = .fullScreen
            Global_TopViewController!.present(loginVC, animated: true, completion: nil)
            CommonCache.share.userDataCache.removeObject(forKey: CacheKey.userDataInfoCacheKey)
            CommonCache.share.userDataCache.removeAllObjects()
//        }
        // 设置导航栏标题
        let navBar = UINavigationBar.appearance()
        //取消导航栏下的黑线
        navBar.setBackgroundImage(UIImage(), for: .bottom, barMetrics: .default)
        navBar.shadowImage = UIImage()
        navBar.barTintColor = UIColor.white
        
        //开启本地服务器，用来加载fbx文件
        let vc = ViewController()
        vc.startLocalServer()
        
        networkReachability()
        
        return true
    }

    // MARK: UISceneSession Lifecycle


}

extension AppDelegate {
    func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

extension UIDevice {
    
    class func deviceMandatoryLandscapeWithNewOrientation(interfaceOrientation: UIInterfaceOrientation) {
        
        let defaultRotation = UIInterfaceOrientation.unknown.rawValue
        let number = NSNumber.init(value: defaultRotation)
        
        UIDevice.current.setValue(number, forKey: "orientation")
        
        let inputRotation = interfaceOrientation.rawValue
        let inputNumber = NSNumber.init(value: inputRotation)
        
        UIDevice.current.setValue(inputNumber, forKey: "orientation")
    }
}
//MARK: - 网络监听
extension AppDelegate {
    
    private func networkReachability(){
        GYNetworkManager.share.startListeningNetWorking()
    }
}
