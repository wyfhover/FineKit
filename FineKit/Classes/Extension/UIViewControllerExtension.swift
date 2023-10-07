//
//  UIViewControllerExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension FineKitWrapper where Base: UIViewController {
    
    /// 清除导航栏Item
    /// - Parameter left: nil：清除所有
    func setNaviItemClear(left: Bool?) {
        guard let naviVC = self.base.navigationController else { return }
        if left == nil {
            naviVC.navigationBar.topItem?.leftBarButtonItem = nil
            naviVC.navigationBar.topItem?.rightBarButtonItem = nil
            naviVC.navigationItem.leftBarButtonItem = nil
            naviVC.navigationItem.rightBarButtonItem = nil
        } else if let kLeft = left {
            if kLeft {
                naviVC.navigationBar.topItem?.leftBarButtonItem = nil
                naviVC.navigationItem.leftBarButtonItem = nil
            } else {
                naviVC.navigationBar.topItem?.rightBarButtonItem = nil
                naviVC.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    /// 清除导航栏颜色
    func clearNaviColor() {
        self.setNavi(color: UIColor.clear)
    }
    
    /// 设置导航栏颜色
    /// - Parameter color: color
    func setNavi(color: UIColor ) {
        guard let naviVC = self.base.navigationController else { return }
        if #available(iOS 13, *) {
            let appeance = naviVC.navigationBar.standardAppearance.copy()
            
            if color == .clear {
                appeance.configureWithTransparentBackground()
                appeance.backgroundImage = UIImage()
                appeance.shadowImage = UIImage()
                
            } else {
//                appeance.configureWithOpaqueBackground()
                appeance.backgroundImage = UIImage.fk.from(color: color)
                appeance.shadowImage = UIImage.fk.from(color: color)
            }
            appeance.backgroundColor = color
            appeance.shadowColor = color
            
            naviVC.navigationBar.standardAppearance = appeance
            
            if #available(iOS 15, *) {
                naviVC.navigationBar.scrollEdgeAppearance = appeance
            }
        } else {
            naviVC.navigationBar.setBackgroundImage(UIImage.fk.from(color: color), for: .default)
        }
    }
    
    /// 设置导航栏颜色
    /// - Parameter image: 图片
    func setNavi(image: UIImage ) {
        guard let naviVC = self.base.navigationController else { return }
        if #available(iOS 13, *) {
            let appeance = naviVC.navigationBar.standardAppearance
            
            appeance.configureWithTransparentBackground()
            appeance.backgroundImage = image
            appeance.backgroundColor = .clear
            
//            naviVC.navigationBar.standardAppearance = appeance
            
            if #available(iOS 15, *) {
                naviVC.navigationBar.scrollEdgeAppearance = appeance
            }
        } else {
            naviVC.navigationBar.setBackgroundImage(image, for: .default)
        }
    }
    
    /// 隐藏导航栏阴影线
    func setNaviShadowHidden() {
        var naviVC: UINavigationController? = nil
        if let tNaviVC = self.base as? UINavigationController {
            naviVC = tNaviVC
        } else if let tNaviVC = self.base.navigationController {
            naviVC = tNaviVC
        }
        
        guard let kNaviVC = naviVC else { return }
        
        if #available(iOS 13, *) {
            let appeance = kNaviVC.navigationBar.standardAppearance
            appeance.shadowImage = UIImage()
            kNaviVC.navigationBar.standardAppearance = appeance
//            if #available(iOS 15, *) {
//                kNaviVC.navigationBar.scrollEdgeAppearance = appeance
//            }
        } else {
            kNaviVC.navigationBar.shadowImage = UIImage()
        }
    }
    
    /// 隐藏标签栏阴影线
    func setTabbarShadowHidden() {
        var tabbarC: UITabBarController? = nil
        
        if let tTabbarC = self.base as? UITabBarController {
            tabbarC = tTabbarC
        } else if let tTabbarC = self.base.tabBarController {
            tabbarC = tTabbarC
        }
        
        guard let kTabbarC = tabbarC else { return }
        
        if #available(iOS 13, *) {
            let appearance = kTabbarC.tabBar.standardAppearance.copy()
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            kTabbarC.tabBar.standardAppearance = appearance
        } else {
            kTabbarC.tabBar.shadowImage = UIImage()
        }
    }
    
    func setTitle(color: UIColor) {
        guard let naviVC = self.base.navigationController else { return }
        
        if #available(iOS 13, *) {
            let appeance = naviVC.navigationBar.standardAppearance
            
            appeance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            if #available(iOS 15, *) {
                naviVC.navigationBar.scrollEdgeAppearance = appeance
            }
        } else {
            naviVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

// MARK: - 返回手势相关
//public extension FineKitWrapper where Base == UIViewController {
////extension UIViewController: UIGestureRecognizerDelegate {
//
//    /// 添加手势 viewDidAppear调用
//    func addPopGesture() {
//
//        self.base.navigationController?.interactivePopGestureRecognizer?.delegate = self.base as? any UIGestureRecognizerDelegate
//    }
//
//    /// 禁用返回手势 viewWillAppear || viewDidAppear调用 设置UIGestureRecognizerDelegate代理后
//    func popGestureClose() {
//        self.base.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//   }
//
//    /// 启用返回手势 viewWillDisappear调用
//    func popGestureOpen() {
//        self.base.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//   }
//
//    // MARK: - UIGestureRecognizerDelegate
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard let naviVC = self.base.navigationController else { return false }
//        if gestureRecognizer == naviVC.interactivePopGestureRecognizer {
//            if let visibleVC = naviVC.visibleViewController, let index = naviVC.viewControllers.firstIndex(of: visibleVC) {
//                return naviVC.viewControllers.count > 1 && index > 0
//            } else {
//                return false
//            }
//        }
//        return true
//    }
//}
