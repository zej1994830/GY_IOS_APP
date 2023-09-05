//
//  UIExtension.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit

extension UIColor {
    
    
    /// 样式 #5B5B5B
    ///
    /// - Parameters:
    ///   - color_vaule: 传入#5B5B5B格式的字符串
    ///   - alpha: 传入透明度
    /// - Returns: 颜色
    class func UIColorFromHexvalue(color_vaule : String , alpha : CGFloat = 1) -> UIColor {
        
        if color_vaule.isEmpty {
            return UIColor.clear
        }
        
        var cString = color_vaule.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count == 0 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count < 6 && cString.count != 6 {
            
            return UIColor.clear
        }
        
        let value = "0x\(cString)"
        
        let scanner = Scanner(string:value)
        
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
              let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
              let blueValue = CGFloat(hexValue & 0xFF)/255.0
              return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return UIColor.clear
        }
    }
    
    
    func alpha(_ alpha: CGFloat) -> UIColor {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alphatemp: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alphatemp)
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //颜色生成图片
    func createImage(_ size: CGSize)-> UIImage{
        let rect = CGRect.init(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
