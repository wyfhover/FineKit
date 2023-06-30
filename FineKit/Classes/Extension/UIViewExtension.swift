//
//  UIViewExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension UIView {
    func add(views: [UIView]) {
        views.forEach { v in
            self.addSubview(v)
        }
    }
    
    var width : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var centerX : CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY : CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var maxY : CGFloat{
        get {
            return self.y + self.height
        }
        set {
            self.y = newValue - self.height
        }
    }
    
    var maxX : CGFloat{
        get {
            return self.x + self.width
        }
        set {
            self.x = newValue - self.width
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    
    var kCenter: CGPoint {
        get {
            return CGPoint(x: self.width / 2, y: self.height / 2)
        }
    }
}

public extension UIView {
    
    /// ShapeLayer绘制圆角
    /// - Parameters:
    ///   - radius: 半径
    ///   - type: UIRectCorner
    func setCornerRadius(_ radius:CGFloat, type: UIRectCorner){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: type, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer();
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer;
    }
    
    /// layer圆角（离屏渲染）
    /// - Parameters:
    ///   - radius: 半径
    ///   - mask: 裁剪
    func setCornerRadius(_ radius:CGFloat, mask: Bool = true){
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = radius
    }
    
    /// layer属性设置
    /// - Parameters:
    ///   - borderWidth: 边宽
    ///   - borderColor: 边色
    func setBorderProperty(width borderWidth:CGFloat,_ borderColor:UIColor = UIColor.black){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

public extension UIView {
    
    /// 根据给定的约束宽，获取合适的高
    /// - Parameter width: 约束宽
    func getRightHeight(width: CGFloat) -> CGFloat {
        return self.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height
    }
    
    /// 根据给定的约束高，获取合适的宽
    /// - Parameter width: 约束高
    func getRightWidth(height: CGFloat) -> CGFloat {
        return self.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height)).width
    }
}

@available(iOS 10.0, *)
public extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

