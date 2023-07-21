//
//  UIColorExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension FineKitWrapper where Base == UIColor.Type {
    var random: UIColor {
        get{
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 0-255 的RGBA颜色设置
    func hex<T>(_ red: T, _ green: T, _ blue: T, _ alpha: T = 255) -> UIColor where T: UnsignedInteger {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    /// 无符号32整形 RGBA颜色设置，若无透明度默认0xFF
    /// - Parameters:
    ///   - hexInt: 颜色值 0xAABBCC
    ///   - alpha: 透明度 0 - 255
    func hex(_ hexInt: UInt32, alpha: UInt8 = 0xFF) -> UIColor {
        let r = UInt8((hexInt & 0xFF0000) >> 16)
        let g = UInt8((hexInt & 0x00FF00) >> 8)
        let b = UInt8((hexInt & 0x0000FF) >> 0)
        let a: UInt8 = alpha
        return self.hex(r, g, b, a)
    }
    
    private func fixup(hexStr: String) -> String {
        var tHex = hexStr
        
        // 将字符串转成大写
        tHex = tHex.uppercased()
        
        // 掐头
        if tHex.hasPrefix("0x") || tHex.hasPrefix("##") || tHex.hasPrefix("0X") {
            tHex = String(tHex.dropFirst(2))
        }
        if tHex.hasPrefix("#") {
            tHex = String(tHex.dropFirst())
        }
        
        // 补尾
        while tHex.count < 6 {
            tHex.append("0")
        }
        
        return tHex
    }
    
    /// 字符串 RGBA颜色设置，若无透明度默认0xFF
    /// - Parameter hexStr: 前缀可为0x、0X、##、#，或为空
    /// 颜色值如"RRGGBB"，可带透明度"RRGGBBAA"
    /// 长度不足6位后位填充0
    func hex(_ hexStr: String) -> UIColor {
        let tHex = self.fixup(hexStr: hexStr)
        
        //4.分别截取RGB
        var range = NSRange(location: 0, length: 2)
        let rHex = (tHex as NSString).substring(with: range)
        
        range.location = 2
        let gHex = (tHex as NSString).substring(with: range)
        
        range.location = 4
        let bHex = (tHex as NSString).substring(with: range)
        
        range.location = 6
        var aHex = "FF"
        if tHex.count == 8 {
            aHex = (tHex as NSString).substring(with: range)
        }
        //5.将字符串转化成数字  emoji也是十六进制表示(此处也可用Float类型)
        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0, a: UInt64 = 0
        
        //创建扫描器,将字符串的扫描结果赋值给:r,g,b,a
        Scanner(string: rHex).scanHexInt64(&r)
        Scanner(string: gHex).scanHexInt64(&g)
        Scanner(string: bHex).scanHexInt64(&b)
        Scanner(string: aHex).scanHexInt64(&a)
        
        return self.hex(r, g, b, a)
    }
    
    /// 字符串 RGBA颜色设置，若无透明度默认0xFF
    /// - Parameters:
    ///   - hexStr: 前缀可为0x、0X、##、#，或为空
    ///   - alpha: 透明度，若hexStr含透明度，则使用hexStr的透明度，默认1
    func hex(_ hexStr: String, alpha: Float = 1.0) -> UIColor {
        
        let tHex = self.fixup(hexStr: hexStr)
        
        if tHex.count == 8 {
            return self.hex(hexStr)
        }
        
        var kAlpha = alpha
        if kAlpha > 1 {
            kAlpha = 1
        } else if kAlpha < 0 {
            kAlpha = 0
        }
        
        let alpha_uint8: UInt8 = UInt8(roundf(kAlpha * 255.0))
        let aHex = String(format: "%02X", alpha_uint8)
                
        return self.hex(hexStr + aHex)
    }
}

public extension FineKitWrapper where Base == UIColor {
    
    /// 修改透明度
    /// - Parameter value: [0.0...1.0]
    func alpha(_ value: CGFloat) -> UIColor {
        return self.base.withAlphaComponent(value)
    }
    
    
}

public extension FineKitWrapper where Base == UIColor.Type {
    enum GradientDirection : Int {
        case vertical = 0

        case horizontal = 1
        
        case radar = 2
    }
    
    /// Core Graphics(Quartz 2D) 绘制渐变颜色
    /// - Parameters:
    ///   - colors: 颜色组
    ///   - locations: 0-1范围的色点，标记每个颜色在0-1范围位置点
    ///   - size: 视图的大小
    ///   - direction: 渐变颜色的方向 radar为环状渐变，类似雷达水波纹
    func gradient(colors: [UIColor], locations: [CGFloat], size: CGSize, direction: GradientDirection ) -> UIColor {
        UIGraphicsBeginImageContextWithOptions(size, false, 0) //开启图片上下文
        guard let context = UIGraphicsGetCurrentContext() else { return UIColor.white } // 获取上下文
        let colorSpace = CGColorSpaceCreateDeviceRGB() // 开启颜色空间
        var tLocations = locations
        var colorComponents: [CGFloat] = []
        
        // 获取每个颜色的RGBA色值
        colors.forEach { color in
            if let rgbas = color.cgColor.components {
                colorComponents.append(contentsOf: rgbas)
            }
        }
        guard let gradient =  CGGradient(colorSpace: colorSpace, colorComponents: &colorComponents, locations: &tLocations, count: colors.count) else { return UIColor.white }
        
        switch direction {
        case .vertical:
            context.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: size.height), options: .drawsBeforeStartLocation)
        case .horizontal:
            context.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: size.width, y: 0), options: .drawsBeforeStartLocation)
        case .radar:
            let center = CGPoint(x: size.width / 2, y: size.height / 2) //起始圆 与 结束圆公用同个中心点
            let endRadius = max(size.width, size.height) / 2 // 结束半径 使用宽高最大值
            let startRadius = endRadius / CGFloat(colors.count) // 等比划分色圈
            context.drawRadialGradient(gradient, startCenter: center, startRadius: startRadius, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIColor.white }
        
        return UIColor(patternImage: image)
    }
}
