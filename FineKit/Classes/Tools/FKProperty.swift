//
//  FKProperty.swift
//  Tools
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

// MARK: - 视图相关属性
public let SCREEN = UIScreen.main
public var SCREENWIDTH: CGFloat{
    get {
        return SCREEN.bounds.size.width
    }
}
public var SCREENHEIGHT: CGFloat {
    get {
        return SCREEN.bounds.size.height
    }
}

public var STATUSBARHEIGHT: CGFloat {
    get {
        if #available(iOS 11.0, *) {
    //        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    //        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            return WindowSafeArea.top
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

//let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

public let APPWINDOW = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

public let iPad = UIDevice.current.model.contains("iPad")

public let iPhoneX :Bool = {
//    return UIScreen.main.bounds.height >= 812 ? true : false
    if #available(iOS 11, *) {
        return  WindowSafeArea.bottom > 0
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 LE（Less Equal）高小于等于812
public let iPhoneX_LE812 :Bool = { // Less Equal
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return  WindowSafeArea.bottom > 0 && height <= 812
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 G(Great) LE(Less Equal)  高大于812 且小于等于896
public let iPhoneX_G812_LE896 :Bool = { // Great _ Less Equal
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return  WindowSafeArea.bottom > 0 && height > 812 && height <= 896
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 G(Great) 高大于896
public let iPhoneX_G896 :Bool = { // Great
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return  WindowSafeArea.bottom > 0 && height > 896
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

public let iPhone5: Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(568))
}()

public let iPhone678:Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(667))
}()

public let iPhone678P:Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(736))
}()

public let NavBarRealHeight : CGFloat = 44

public let NavBarHeight : CGFloat = {
    
    let statusAndBarHeight = STATUSBARHEIGHT + NavBarRealHeight
    return statusAndBarHeight
}()

public let TabbarHeight:CGFloat = {
    let iPadorNotXHeight = 49.0
    let iPhoneXHeight = 83.0
    if iPad {
        return 49.0
    }
    if iPhoneX {
        return 83.0
    }
    return 49.0
}()

public let WindowSafeArea : UIEdgeInsets = {
    let `default` = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *){
//        var safe = UIApplication.shared.delegate?.window??.safeAreaInsets
//        if safe?.top == 0 {
//            safe = `default`
//        }
//        return safe ?? `default`
        var safe = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets
        return safe ?? `default`
    }
    return `default`
}()
