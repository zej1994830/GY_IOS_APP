//
//  GYViewController.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit
import JXSegmentedView
import SnapKit
import Alamofire

class GYViewController: UIViewController,UIGestureRecognizerDelegate {
    lazy var noDataView: GYNoDataView = {
        let view = GYNoDataView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(refresh)))
        view.frame = self.view.bounds
        view.isHidden = true
        return view
    }()
    
    var isHiddenNavigationBar: Bool = false{
        didSet{
            self.navigationController?.setNavigationBarHidden(isHiddenNavigationBar, animated: true)
        }
    }
    
    var isInterfaceOrientationRight: Bool = false
    
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    var topHeight: CGFloat {
        return navigationBarHeight + statusBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorConstant.mainBackground
        self.view.addSubview(noDataView)
        setNavigationBarBackButton()
        setRightButton("my_baojing", target: self, action: #selector(warn), for: .touchUpInside)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navBarAlpha = 1
        self.navTintColor = UIColor.black
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: .medium)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isInterfaceOrientationRight{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.allowRotation = true
            UIDevice.deviceMandatoryLandscapeWithNewOrientation(interfaceOrientation: .landscapeRight)
        }
        
        self.view.bringSubviewToFront(noDataView)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /// 不知道为什么 viewDidDisappear调用时间太早了
    deinit {
        if isInterfaceOrientationRight{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.allowRotation = false
            UIDevice.deviceMandatoryLandscapeWithNewOrientation(interfaceOrientation: .portrait)
        }
    }
    
}
extension GYViewController {
    
    @objc func setNavigationBarBackButton(){
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let image = UIImage.init(named: "nav_back")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    func setRightButton(_ imageName: String, target: Any?, action: Selector, for controlEvents: UIControl.Event){
        
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        let image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: controlEvents)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
}

extension GYViewController {
    
    @objc func back(){
     
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20, weight: .medium)]
    }
    
    @objc func warn() {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


//MARK: - 事件
extension GYViewController {
    
    @objc func refresh(){
        
        /// 子类复写
    }
}
extension GYViewController: JXSegmentedListContainerViewListDelegate {
    
    @objc func listView() -> UIView {
        return view
    }

    @objc func listDidAppear() {
        //因为`JXSegmentedListContainerView`内部通过`UICollectionView`的cell加载列表。当切换tab的时候，之前的列表所在的cell就被回收到缓存池，就会从视图层级树里面被剔除掉，即没有显示出来且不在视图层级里面。这个时候MJRefreshHeader所持有的UIActivityIndicatorView就会被设置hidden。所以需要在列表显示的时候，且isRefreshing==YES的时候，再让UIActivityIndicatorView重新开启动画。
//        if (self.tableView.mj_header.isRefreshing) {
//            UIActivityIndicatorView *activity = [self.tableView.mj_header valueForKey:@"loadingView"];
//            [activity startAnimating];
//        }
//        print("listDidAppear")
    }

    @objc func listDidDisappear() {
//        print("listDidDisappear")
    }
}
