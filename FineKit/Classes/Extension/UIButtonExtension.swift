//
//  UIButtonExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

private var KEY_BUTTON_IS_COUNTDOWN = "KEY_BUTTON_IS_COUNTDOWN"

public extension FineKitWrapper where Base == UIButton {
    
    /// 是否正在倒计时
    var isCountdown: Bool {
        set {
            objc_setAssociatedObject(self, &KEY_BUTTON_IS_COUNTDOWN, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }

        get {
            if let kIsCountdown = objc_getAssociatedObject(self, &KEY_BUTTON_IS_COUNTDOWN) as? Bool {
                return kIsCountdown
            } else {
                return false
            }
        }
    }
    
    /// 按钮倒计时 用于验证短信发送
    ///
    /// - Parameters:
    ///   - count: 倒计时长
    ///   - message: 显示信息，带count参数占位符
    mutating func startCountdown(count: Int = 60, message: String = "%d", color: UIColor? = nil) {
        let title = self.base.currentTitle!
        var countTime = count
        let titleColor = self.base.currentTitleColor
        
        self.base.fk.isCountdown = true
        self.base.isEnabled = false
        
        let time = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        
        time.schedule(deadline: .now(), repeating: .seconds(1))
        
        time.setEventHandler { [weak base = self.base] in
            guard var kBase = base else { return }
            
            countTime = countTime - 1
            
            if countTime <= 0 {
                time.cancel()
                
                kBase.fk.isCountdown = false
                kBase.isEnabled = true
                kBase.setTitleColor(titleColor, for: .normal)
                kBase.setTitle(title, for: .normal)
                
            } else {
                kBase.setTitle(String(format: message, countTime), for: .normal)
                kBase.setTitleColor(color, for: .normal)
            }
        }
        
        time.resume()
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.base.setBackgroundImage(UIImage.fk.from(color: color), for: state)
    }
    
    static func cz_init(image: UIImage?, highlight: UIImage?, select: UIImage?) -> Base {
        let button = Base(type: .custom)
        button.fk.cz_setImage(image, highlight: highlight, select: select)
        return button
    }
    
    static func cz_init(title: String?, font: UIFont?, color: UIColor?, highlightTitle: String? = nil, selectTitle: String? = nil, highlightColor: UIColor? = nil, selectColor: UIColor? = nil) -> Base {
        let button = Base(type: .custom)
        button.fk.cz_setTitle(title, highlightTitle: highlightTitle, selectTitle: selectTitle, font: font, color: color, highlightColor: highlightColor, selectColor: selectColor)
        return button
    }
    
    func cz_setTitle(_ title: String?, highlightTitle: String?, selectTitle: String?, font: UIFont?, color: UIColor?, highlightColor: UIColor?, selectColor: UIColor?) {
        self.base.setTitle(title, for: .normal)
        self.base.setTitle(highlightTitle, for: .highlighted)
        self.base.setTitle(selectTitle, for: .selected)
        
        self.base.setTitleColor(color, for: .normal)
        self.base.setTitleColor(highlightColor, for: .highlighted)
        self.base.setTitleColor(selectColor, for: .selected)
        
        self.base.titleLabel?.font = font
    }
    
    func cz_setImage(_ image: UIImage?, highlight: UIImage?, select: UIImage?) {
        self.base.setImage(image, for: .normal)
        self.base.setImage(highlight, for: .highlighted)
        self.base.setImage(select, for: .selected)
    }
}

public extension FineKitWrapper where Base == UIButton {
    func setRightImage(){
        let imvWidth = self.base.imageView!.bounds.size.width + 5
        let labelWidth = self.base.titleLabel!.bounds.size.width
        self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imvWidth, bottom: 0, right: imvWidth)
        self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
    }
}

//MARK: -定义button相对label的位置
public enum WButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}

public extension FineKitWrapper where Base == UIButton {
    
    /// 重新布局lable 和 image
    /// - Parameters:
    ///   - style: 定义button相对label的位置
    ///   - imageTitleSpace: lable 和 image 间距
    func layoutButton(style: WButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.base.imageView?.frame.size.width
        let imageHeight = self.base.imageView?.frame.size.height
        
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.base.titleLabel?.intrinsicContentSize.width
        labelHeight = self.base.titleLabel?.intrinsicContentSize.height
//        labelWidth = self.titleLabel?.getRightWidth(height: self.bounds.height)
//        labelHeight = self.titleLabel?.getRightWidth(height: self.bounds.width)
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .Top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
            break;
            
        case .Left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
            break;
            
        case .Bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .Right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
            break;
            
        }
        
        self.base.titleEdgeInsets = labelEdgeInsets
        self.base.imageEdgeInsets = imageEdgeInsets
        
    }
}
