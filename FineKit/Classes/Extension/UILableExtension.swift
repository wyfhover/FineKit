//
//  UILableExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

public extension FineKitWrapper where Base == UILabel.Type {

    func cz_init(text: String, font: UIFont?, color: UIColor?) -> UILabel {
        let lab = UILabel()
        lab.text = text
        lab.font = font
        lab.textColor = color
        
        return lab
    }
}

public extension FineKitWrapper where Base == UILabel {
    /// 设置富文本
    /// - Parameters:
    ///   - font: 字体
    ///   - color: 颜色
    ///   - LineSpace: 行间距
    ///   - wordSpace: 字间距
    func set(font: UIFont? = nil, color: UIColor? = nil, LineSpace: CGFloat? = nil, wordSpace: CGFloat? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = self.base.lineBreakMode
        paragraphStyle.alignment = self.base.textAlignment
        
        if let kLineSpace = LineSpace {
            paragraphStyle.lineSpacing = kLineSpace
        }
        
        let mas = NSMutableAttributedString(string: self.base.text ?? "")
        
        if let kFont = font {
            mas.addAttribute(NSAttributedString.Key.font, value: kFont, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        } else if let kFont = self.base.font {
            mas.addAttribute(NSAttributedString.Key.font, value: kFont, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        }
        
        if let kColor = color {
            mas.addAttribute(NSAttributedString.Key.foregroundColor, value: kColor, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        } else if let kColor = self.base.textColor {
            mas.addAttribute(NSAttributedString.Key.foregroundColor, value: kColor, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        }
        
        if let kWordSpace = wordSpace {
            mas.addAttribute(NSAttributedString.Key.kern, value: kWordSpace, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        }
        
        mas.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: self.base.text?.count ?? 0))
        
        self.base.attributedText = mas
    }
}
