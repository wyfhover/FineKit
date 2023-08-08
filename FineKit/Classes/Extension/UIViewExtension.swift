//
//  UIViewExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension FineKitWrapper where Base: UIView {
    func add(views: [UIView]) {
        views.forEach { v in
            self.base.addSubview(v)
        }
    }
    
    var width : CGFloat {
        get {
            return self.base.frame.size.width
        }
        set {
            self.base.frame.size.width = newValue
        }
    }
    
    var height : CGFloat {
        get {
            return self.base.frame.size.height
        }
        set {
            self.base.frame.size.height = newValue
        }
    }
    
    var x : CGFloat {
        get {
            return self.base.frame.origin.x
        }
        set {
            self.base.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.base.frame.origin.y
        }
        set {
            self.base.frame.origin.y = newValue
        }
    }
    
    var centerX : CGFloat {
        get {
            return self.base.center.x
        }
        set {
            self.base.center = CGPoint(x: newValue, y: self.base.center.y)
        }
    }
    
    var centerY : CGFloat {
        get {
            return self.base.center.y
        }
        set {
            self.base.center = CGPoint(x: self.base.center.x, y: newValue)
        }
    }
    
//    var maxY : CGFloat{
//        get {
//            return self.y + self.height
//        }
//    }
//    
//    var maxX : CGFloat{
//        get {
//            return self.x + self.width
//        }
//    }
    
    var size: CGSize {
        get {
            return self.base.frame.size
        }
        set {
            self.base.frame.size = newValue
        }
    }
    
    var kCenter: CGPoint {
        get {
            return CGPoint(x: self.width / 2, y: self.height / 2)
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        }
        set {
            self.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.height
        }
        set {
            self.height = newValue - self.y
        }
    }
    
    var leading: CGFloat {
        get {
            return self.x
        }
        set {
            self.x = newValue
        }
    }
    
    var trailing : CGFloat {
        get {
            return self.x + self.width
        }
        set {
            self.width = newValue - self.x
        }
    }
}

public extension FineKitWrapper where Base: UIView {
    
    /// ShapeLayer绘制圆角
    /// - Parameters:
    ///   - radius: 半径
    ///   - type: UIRectCorner
    func setCornerRadius(_ radius:CGFloat, type: UIRectCorner){
        let maskPath = UIBezierPath(roundedRect: self.base.bounds, byRoundingCorners: type, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer();
        maskLayer.frame = self.base.bounds
        maskLayer.path = maskPath.cgPath
        self.base.layer.mask = maskLayer;
    }
    
    /// layer圆角（离屏渲染）
    /// - Parameters:
    ///   - radius: 半径
    ///   - mask: 裁剪
    func setCornerRadius(_ radius:CGFloat, mask: Bool = true){
        self.base.layer.masksToBounds = mask
        self.base.layer.cornerRadius = radius
    }
    
    /// layer属性设置
    /// - Parameters:
    ///   - borderWidth: 边宽
    ///   - borderColor: 边色
    func setBorderProperty(width borderWidth: CGFloat, _ borderColor: UIColor = UIColor.black){
        if let kLayer = self.base.layer.mask as? CAShapeLayer {
            let layer = CAShapeLayer()
            layer.path = kLayer.path
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = borderColor.cgColor
            layer.lineWidth = borderWidth
            layer.frame = self.base.bounds
            
            self.base.layer.addSublayer(layer)
        } else {
            self.base.layer.borderWidth = borderWidth
            self.base.layer.borderColor = borderColor.cgColor
        }
    }
}

public extension FineKitWrapper where Base: UIView {
    
    /// 根据给定的约束宽，获取合适的高
    /// - Parameter width: 约束宽
    func getRightHeight(width: CGFloat) -> CGFloat {
        return self.base.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height
    }
    
    /// 根据给定的约束高，获取合适的宽
    /// - Parameter width: 约束高
    func getRightWidth(height: CGFloat) -> CGFloat {
        return self.base.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: height)).width
    }
}

@available(iOS 10.0, *)
public extension FineKitWrapper where Base: UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.base.bounds)
        return renderer.image { rendererContext in
            self.base.layer.render(in: rendererContext.cgContext)
        }
    }
}

