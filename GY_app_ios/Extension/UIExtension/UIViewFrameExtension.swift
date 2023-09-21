//
//  UIViewFrameExtension.swift
//  GY_app_ios
//
//  Created by zhaoenjia on 2023/8/1.
//

import UIKit
extension UIView {
    
    // 扩展 x 的 set get 方法
    var x: CGFloat{
        get{
            return frame.origin.x
        }
        set(newX){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.x = newX
            frame = tmpFrame
        }
    }

    // 扩展 y 的 set get 方法
    var y: CGFloat{
        get{
            return frame.origin.y
        }
        set(newY){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.y = newY
            frame = tmpFrame
        }
    }

    // 扩展 width 的 set get 方法
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set(newWidth){
            var tmpFrameWidth: CGRect = frame
            tmpFrameWidth.size.width = newWidth
            frame = tmpFrameWidth
        }
    }

    // 扩展 height 的 set get 方法
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set(newHeight){
            var tmpFrameHeight: CGRect = frame
            tmpFrameHeight.size.height = newHeight
            frame = tmpFrameHeight
        }
    }

    // 扩展 centerX 的 set get 方法
    var centerX: CGFloat{
        get{
            return center.x
        }
        set(newCenterX){
            center = CGPoint(x: newCenterX, y: center.y)
        }
    }

    // 扩展 centerY 的 set get 方法
    var centerY: CGFloat{
        get{
            return center.y
        }
        set(newCenterY){
            center = CGPoint(x: center.x, y: newCenterY)
        }
    }
    
    // 扩展 origin 的 set get 方法
    var origin: CGPoint{
        get{
            return CGPoint(x: x, y: y)
        }
        set(newOrigin){
            x = newOrigin.x
            y = newOrigin.y
        }
    }

    // 扩展 size 的 set get 方法
    var size: CGSize{
        get{
            return CGSize(width: width, height: height)
        }
        set(newSize){
            width = newSize.width
            height = newSize.height
        }
    }

    // 扩展 left 的 set get 方法
    var left: CGFloat{
        get{
            return x
        }
        set(newLeft){
            x = newLeft
        }
    }

    // 扩展 right 的 set get 方法
    var right: CGFloat{
        get{
            return x + width
        }
        set(newNight){
            x = newNight - width
        }
    }

    // 扩展 top 的 set get 方法
    var top: CGFloat{
        get{
            return y
        }
        set(newTop){
            y = newTop
        }
    }

    // 扩展 bottom 的 set get 方法
    var bottom: CGFloat{
        get{
            return  y + height
        }
        set(newBottom){
            y = newBottom - height
        }
    }
}

extension UIView {
    
    /**

    * 设置uiview 的任意圆角 // 默认全设置

    **/

    func SetMutiBorderRoundingCorners(_ corner: CGFloat, roundingCorners: UIRectCorner = [UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight, UIRectCorner.topLeft])

    {

        self.layoutIfNeeded()
        
        let maskPath = UIBezierPath.init(roundedRect: self.bounds,

        byRoundingCorners: roundingCorners,

        cornerRadii: CGSize(width: corner, height: corner))

        let maskLayer = CAShapeLayer()

        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        
        maskLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        maskLayer.shadowOffset = CGSize(width: 0, height: 0)
        maskLayer.shadowOpacity = 1
        maskLayer.shadowRadius = 6
        
//        self.layer.addSublayer(maskLayer)
        self.layer.mask = maskLayer

    }
    
    
    func setCommonShadow(){
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 6
    }
}
extension UIView {
    //虚线
    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = self.bounds
    //        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPhase = 0 //从哪个位置开始
            //每一段虚线长度 和 每两段虚线之间的间隔
            shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    
}
