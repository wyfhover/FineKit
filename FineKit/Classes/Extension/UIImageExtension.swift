//
//  UIImageExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import Foundation

public extension UIImage {
    
    static func image(_ text:String,
                      size:CGSize,
                      font:UIFont,
                      backColor:UIColor,
                      textColor:UIColor) -> UIImage?{
        if text.isEmpty { return nil }
        let letter = text
        let rect = CGRect(origin: CGPoint.zero, size: size)
        //UIGraphicsBeginImageContext(size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setFillColor(backColor.cgColor)
        ctx.fill(rect)
        let attr = [ NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : font]
        (letter as NSString).draw(in: rect, withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIImage {
    
    /// 修改大小
    /// - Parameter size: 尺寸
    func toSize(_ size: CGFloat) -> UIImage {
        return self.toSize(size, size)
    }
    
    /// 修改大小
    /// - Parameters:
    ///   - width: 宽
    ///   - height: 高
    func toSize(_ width: CGFloat, _ height: CGFloat) -> UIImage{
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions (size, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        let context = UIGraphicsGetCurrentContext() // 获取上下文
//        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        context?.fill(rect) //填充布局
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    
    /// 等比例缩放
    /// - Parameter scale: 倍率
    func toScale(_ scale: CGFloat) -> UIImage {
        return self.toSize(self.size.width * scale, self.size.height * scale)
    }
    
    /// 颜色绘制图片
    /// - Parameter color: 颜色
    class func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size) // 开启上下文
        let context = UIGraphicsGetCurrentContext() // 获取上下文
        context?.setFillColor(color.cgColor) //填充颜色
        context?.fill(rect) //填充布局
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage() // 从上下文获取image
        UIGraphicsEndImageContext() //关闭上下文
        return image
    }
    
    
//    class func tempBunel() -> Bundle? {
//
//        guard var url = Bundle.main.url(forResource: "Frameworks", withExtension: nil) else {
//            return nil
//        }
//        url = url.appendingPathComponent("Extension")
//        url = url.appendingPathExtension("framework")
//        let newBundle = Bundle(url: url)
//
//        let bundleUrl = newBundle?.url(forResource: "ExtensionBundle", withExtension: "bundle")
//
//        return Bundle(url: bundleUrl!)
//    }
}
