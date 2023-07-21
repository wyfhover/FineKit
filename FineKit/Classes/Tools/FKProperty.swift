//
//  FKProperty.swift
//  Tools
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

// MARK: - 视图相关属性
public let FKScreen = UIScreen.main
public var FKScreenWidth: CGFloat{
    get {
        return FKScreen.bounds.size.width
    }
}
public var FKScreenHeight: CGFloat {
    get {
        return FKScreen.bounds.size.height
    }
}

public let FKWindowSafeArea : UIEdgeInsets = {
    let `default` = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *){
//        var safe = UIApplication.shared.delegate?.window??.safeAreaInsets
//        if safe?.top == 0 {
//            safe = `default`
//        }
//        return safe ?? `default`
        return FKKeyWindow?.safeAreaInsets ?? `default`
    }
    return `default`
}()

public var FKStatusBarHeight: CGFloat {
    get {
        if #available(iOS 11.0, *) {
    //        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    //        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            return FKWindowSafeArea.top
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
}

//let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
//public let APPWINDOW = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

public var FKKeyWindow: UIWindow? {
    get {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if #available(iOS 15.0, *) {
                    return scene.keyWindow
                } else {
                    return scene.windows.first(where: { $0.isKeyWindow })
                }
            }
        }
        return UIApplication.shared.keyWindow
    }
}

public var FKRootViewController: UIViewController? {
    get {
        guard let window = FKKeyWindow else { return nil }
        guard let root = window.rootViewController else { return nil }
        
        return root
    }
}

public var FKTopViewController: UIViewController? {
    get {
        guard let root = FKRootViewController else { return nil }
        
        if let navi = root as? UINavigationController, let vc = navi.topViewController {
            return vc
        }
        
        if let tab = root as? UITabBarController, let vc = tab.selectedViewController {
            return vc
        }
        
        return root
    }
}

public let FK_iPad = UIDevice.current.model.contains("iPad")

public let FK_iPhoneX :Bool = {
//    return UIScreen.main.bounds.height >= 812 ? true : false
    if #available(iOS 11, *) {
        return  FKWindowSafeArea.bottom > 0
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 LE（Less Equal）高小于等于812
public let FK_iPhoneX_LE812 :Bool = { // Less Equal
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return  FKWindowSafeArea.bottom > 0 && height <= 812
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 G(Great) LE(Less Equal)  高大于812 且小于等于896
public let FK_iPhoneX_G812_LE896 :Bool = { // Great _ Less Equal
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return  FKWindowSafeArea.bottom > 0 && height > 812 && height <= 896
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

/// 刘海屏系列 G(Great) 高大于896
public let FK_iPhoneX_G896 :Bool = { // Great
    if #available(iOS 11, *) {
        let height = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
        return FKWindowSafeArea.bottom > 0 && height > 896
    } else {
        return false // iPhone X 无低于iOS 11的系统版本
    }
}()

public let FK_iPhone5: Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(568))
}()

public let FK_iPhone678:Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(667))
}()

public let FK_iPhone678P:Bool = {
    return (UIScreen.main.bounds.size.height == CGFloat(736))
}()

public let FKNavBarRealHeight : CGFloat = 44

public let FKNavBarHeight : CGFloat = {
    return FKStatusBarHeight + FKNavBarRealHeight
}()

public let FKTabbarHeight:CGFloat = {
    let iPadorNotXHeight = 49.0
    let iPhoneXHeight = 83.0
    if FK_iPad {
        return 49.0
    }
    if FK_iPhoneX {
        return 83.0
    }
    return 49.0
}()


