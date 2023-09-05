//
//  GYNavigationController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/23.
//

import UIKit

class GYNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addLayout()
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        
        if animated {
            let popVc = self.viewControllers.last
            popVc?.hidesBottomBarWhenPushed = false
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.viewControllers.count == 2 {
            let vc = super.popViewController(animated: animated)
            vc?.hidesBottomBarWhenPushed = false
            return vc
        }
        
        return super.popViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
//        if viewController.self is NotNeedLogin {
//
//            super.pushViewController(viewController, animated: animated)
//        }else{
//
//            if TFUserBaseInfoData.default.isLogin {
//                super.pushViewController(viewController, animated: animated)
//            }else{
//                let loginVC = TFLoginViewController()
//                loginVC.modalPresentationStyle = .fullScreen
//
//                /// 根视图处理
//                if self.viewControllers.count > 0 {
//                    self.viewControllers[0].present(loginVC, animated: true, completion: nil)
//                }else{
//                    super.pushViewController(viewController, animated: animated)
//                }
//            }
//        }
    }
}
extension GYNavigationController {
    
    private func setupViews(){
        self.delegate = self
    }
    
    private func addLayout(){
    }
}

extension GYNavigationController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = self.viewControllers.count > 1
        
        // 根视图
        if self.viewControllers.count == 1 {
            viewController.navigationItem.leftBarButtonItem = nil
            
        }
        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
}

/// 平滑过渡导航栏
extension GYViewController: UIViewControllerInteractiveTransitioning{
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    
}
