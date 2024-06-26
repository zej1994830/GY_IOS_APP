//
//  GYTabbarController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit
import Alamofire

class GYTabbarController: UITabBarController {
    
    ////// 设计成单例,方便在任何地方获取视图层级等相关
    static let share: GYTabbarController = GYTabbarController()
    let vcarray:NSMutableArray = []
    var myTabBar = GYTabBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(self.myTabBar, forKey: "tabBar")
        let vc1 = GYMainViewController()
        let vc2 = GYMyCenterViewController()
//    http://36.129.131.242:8181/api/oauth/auth?user_account=12306&password=123456  ["user_account":"12306","password":"123456"]
        vcarray.addObjects(from: [vc1,vc2])
        self.setViewController(viewController: vc1 , title: "主页", imageName: "nav_home_pre", selectImagePath: "nav_home")
        self.setViewController(viewController: vc2, title: "我的", imageName: "nav_my_pre", selectImagePath: "nav_my")
        
        
    }
    
    func setViewController(viewController: UIViewController,title: String,imageName: String,selectImagePath:String){
        
//        self.tabBar.tintColor = UIColorConstant.textBlack
        viewController.tabBarItem.title = title
        viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColorConstant.textBlack], for: .selected)
        
        viewController.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -8)
        
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 11, left: 11, bottom: 11, right: 11)
        viewController.tabBarItem.image = UIImage.init(named: imageName)?.scalingToSize(CGSize.init(width: 47, height: 47))
        viewController.tabBarItem.selectedImage = UIImage.init(named: selectImagePath)?.scalingToSize(CGSize.init(width: 47, height: 47))
//        viewController.tabBarItem.selectedImage = gifImage(gifPath: selectGifPath)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.UIColorFromHexvalue(color_vaule: "#1A73E8")], for: .selected)
        let navigationController = GYNavigationController.init(rootViewController: viewController)
        self.addChild(navigationController)
    }

    private func gifImage(gifPath: String) -> UIImage? {
        // 1.获取NSData类型
        guard let filePath = Bundle.main.path(forResource: gifPath, ofType: nil) else { return nil }
        guard let fileData = NSData(contentsOfFile: filePath) else { return nil }
                
        // 2.根据Data获取CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return nil }
                
        // 3.获取gif图片中图片的个数
        let frameCount = CGImageSourceGetCount(imageSource)
        // 记录播放时间
        var duration : TimeInterval = 0
        var images = [UIImage]()
        for i in 0..<frameCount {
            // 3.1.获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            // 3.2.获取时长
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
            let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
            
            duration += frameDuration.doubleValue
            let image = UIImage(cgImage: cgImage).withRenderingMode(.alwaysOriginal)
            images.append(image)

        }
        // 4.播放图片
        let image = UIImage.animatedImage(with: images, duration: duration)?.withRenderingMode(.alwaysOriginal)
        return image
    }
}
