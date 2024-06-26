//
//  GYHUD.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/18.
//

import UIKit
import MBProgressHUD
import SDWebImage

class GYHUD: NSObject {
    
    class func show(_ text: String, icon: String = "", view: UIView? = nil){
        let hud = MBProgressHUD.showAdded(to: view ?? UIApplication.shared.windows.last ?? UIView(), animated: true)
        hud.label.text = text
        
        if icon.isEmpty {
            hud.mode = .text
        }else{
            let image = UIImage.init(named: icon)
            hud.customView = UIImageView.init(image: image)
            hud.mode = .customView
        }
        
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColorConstant.black
        hud.label.textColor = UIColorConstant.lightWihte
        hud.contentColor = UIColorConstant.lightWihte
        hud.graceTime = 0.5
        hud.minShowTime = 1
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
    }
    
    class func showGif(view: UIView? = nil){
        let hud = MBProgressHUD.showAdded(to: view ?? UIApplication.shared.windows.last ?? UIView(), animated: true)

        let path = Bundle.main.url(forResource: "loading", withExtension: "gif")
        if path != nil {
            let data = try? Data.init(contentsOf: path!)
            
            let image = UIImage.sd_image(withGIFData: data)
            hud.customView = UIImageView.init(image: image)
        }
        
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor.clear
        hud.label.textColor = UIColorConstant.lightWihte
        hud.contentColor = UIColorConstant.lightWihte
        hud.graceTime = 0.5
        hud.minShowTime = 0.25
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 10)
    }
    
    class func showSuccess(_ success: String, icon: String = "success_hud_icon", view: UIView? = nil){
        self.show(success, icon: icon, view: view)
    }
    
    class func showError(_ error: String, icon: String = "error_hud_icon", view: UIView? = nil){
        self.show(error, icon: icon, view: view)
    }
    
    class func showWarning(_ warning: String, icon: String = "warning_hud_icon", view: UIView? = nil){
        self.show(warning, icon: icon, view: view)
    }
    
    class func showMessageWithIcon(_ success: String, icon: String, view: UIView? = nil){
        self.show(success, icon: icon, view: view)
    }
    
    @discardableResult class func activityMessageHud(_ message: String, view: UIView? = nil) -> MBProgressHUD{
        let viewTemp = view ?? UIApplication.shared.windows.last ?? UIView()
        let hud = MBProgressHUD.init(view: viewTemp)
        hud.mode = .indeterminate
        hud.label.text = message
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColorConstant.black
        hud.label.textColor = UIColorConstant.lightWihte
        hud.contentColor = UIColorConstant.lightWihte
        hud.graceTime = 0.25
        hud.minShowTime = 1
        viewTemp.addSubview(hud)
        return hud
    }
    
    @discardableResult class func showDefaultActivityMessage(_ message: String, view: UIView? = nil) -> MBProgressHUD{
        let viewTemp = view ?? UIApplication.shared.windows.last ?? UIView()
        let hud = MBProgressHUD.init(view: viewTemp)
        hud.mode = .indeterminate
        hud.label.text = message
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColorConstant.black
        hud.label.textColor = UIColorConstant.lightWihte
        hud.contentColor = UIColorConstant.lightWihte
        hud.graceTime = 0.25
        hud.minShowTime = 1
        hud.removeFromSuperViewOnHide = true
        viewTemp.addSubview(hud)
        hud.show(animated: true)
        return hud
    }
    
    @discardableResult class func showActivityMessage(_ message: String, view: UIView? = nil) -> MBProgressHUD{
        let hud = MBProgressHUD.init(view: view ?? UIApplication.shared.windows.last ?? UIView())

        let path = Bundle.main.url(forResource: "loading", withExtension: "gif")
        if path != nil {
            let data = try? Data.init(contentsOf: path!)
            
            let image = UIImage.sd_image(withGIFData: data)
            hud.customView = UIImageView.init(image: image)
        }
        
        hud.mode = .customView
        hud.bezelView.style = .solidColor
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.white.alpha(0.3)
        hud.bezelView.backgroundColor = UIColor.clear
        hud.label.textColor = UIColorConstant.lightWihte
        hud.contentColor = UIColorConstant.lightWihte
        hud.graceTime = 0.25
        hud.minShowTime = 1
        hud.removeFromSuperViewOnHide = true
        hud.show(animated: true)
        return hud
    }
    
    @discardableResult class func showProgressBarToView(_ view:  UIView? = nil) -> MBProgressHUD{
        let hud = MBProgressHUD.showAdded(to: view ?? UIApplication.shared.windows.last ?? UIView(), animated: true)
        hud.mode = .determinate
        hud.label.text = "加载中"
        return hud
    }
    
    class func hideHudForView(_ view:  UIView? = nil){
        MBProgressHUD.hide(for: view ?? UIApplication.shared.windows.last ?? UIView(), animated: true)
    }
    
    class func hideHUD(){
        self.hideHudForView(nil)
    }
}
