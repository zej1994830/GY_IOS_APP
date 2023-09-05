//
//  NumberExtension.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/9/4.
//

import UIKit

extension CGFloat {
    
    static var AppAspectWidth: CGFloat {
        
        if APP.IS_IPAD{
            return 768
        }else{
            return 375
        }
        
    }
    
    static var AppAspectHeight: CGFloat {
        
        if APP.IS_IPAD{
            return 1024
        }else{
            return 667
        }
        
    }
    
    func rellyWidthNumber() -> CGFloat {
        return self * (UIScreen.main.bounds.width / CGFloat.AppAspectWidth)
    }
    
    var rellyHeightNumber: CGFloat {
        return self * (UIScreen.main.bounds.height / CGFloat.AppAspectHeight)
    }
    
    /// aspect: width1 / height1 = width / height
    static func aspectHeight(_ aspect: CGFloat, width: CGFloat) -> CGFloat {
        
        return width / aspect
    }
    
}

extension Float {
    var rellyWidthNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.width / CGFloat.AppAspectWidth)
    }
    
    var rellyHeightNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.height / CGFloat.AppAspectHeight)
    }
}

extension Int {
    var rellyWidthNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.width / CGFloat.AppAspectWidth)
    }
    
    var rellyHeightNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.height / CGFloat.AppAspectHeight)
    }
}

extension Double {
    var rellyWidthNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.width / 768)
    }
    
    var rellyHeightNumber: CGFloat {
        return CGFloat(self) * (UIScreen.main.bounds.height / CGFloat.AppAspectHeight)
    }
}

//MARK: - 小数点相关
extension Float {
    
    func getStringWithPointNumber(_ point: Int) -> String {
        
        return String.init(format: "%.\(point)f", self)
    }
}
