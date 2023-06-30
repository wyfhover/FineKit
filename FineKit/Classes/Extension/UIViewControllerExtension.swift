//
//  UIViewControllerExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    /// 清除导航栏Item
    /// - Parameter left: nil：清除所有
    func setNaviItemClear(left: Bool?) {
        guard let naviVC = self.navigationController else { return }
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
        guard let naviVC = self.navigationController else { return }
        if #available(iOS 13, *) {
            let appeance = naviVC.navigationBar.standardAppearance
            
            if color == .clear {
                appeance.configureWithTransparentBackground()
                appeance.backgroundImage = UIImage()
            } else {
//                appeance.configureWithOpaqueBackground()
                appeance.backgroundImage = UIImage.from(color: color)
            }
            appeance.backgroundColor = color
            
//            naviVC.navigationBar.standardAppearance = appeance
            
            if #available(iOS 15, *) {
                naviVC.navigationBar.scrollEdgeAppearance = appeance
            }
        } else {
            naviVC.navigationBar.setBackgroundImage(UIImage.from(color: color), for: .default)
        }
    }
    
    /// 隐藏导航栏阴影线
    func setShadowHiden() {
        var naviVC: UINavigationController? = nil
        if let tNaviVC = self as? UINavigationController {
            naviVC = tNaviVC
        } else if let tNaviVC = self.navigationController {
            naviVC = tNaviVC
        }
        
        guard let kNaviVC = naviVC else { return }
        
        if #available(iOS 13, *) {
            let appeance = kNaviVC.navigationBar.standardAppearance
            appeance.shadowImage = UIImage()
            
            kNaviVC.navigationBar.standardAppearance = appeance
            if #available(iOS 15, *) {
                kNaviVC.navigationBar.scrollEdgeAppearance = appeance
            }
        } else {
            kNaviVC.navigationBar.shadowImage = UIImage()
        }
    }
}

// MARK: - 返回手势相关
extension UIViewController: UIGestureRecognizerDelegate {
    
    /// 添加手势 viewDidAppear调用
    public func addPopGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /// 禁用返回手势 viewWillAppear || viewDidAppear调用 设置UIGestureRecognizerDelegate代理后
    public func popGestureClose() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
   }
    
    /// 启用返回手势 viewWillDisappear调用
    public func popGestureOpen() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
   }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let naviVC = self.navigationController else { return false }
        if gestureRecognizer == naviVC.interactivePopGestureRecognizer {
            if let visibleVC = naviVC.visibleViewController, let index = naviVC.viewControllers.firstIndex(of: visibleVC) {
                return naviVC.viewControllers.count > 1 && index > 0
            } else {
                return false
            }
        }
        return true
    }
}
