//
//  StringExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    
    /// 版本号转Int
    /// - Parameter version: 版本号
    func versionToInt() -> Int {
        let vers = self.split(separator: ".")
        let count = vers.count
        var ver_int: Int = 0
        for (idx, ver) in vers.enumerated() {
            let value = Double(Int(ver) ?? 0) * pow(100.0, Double(count - 1 - idx))
            ver_int += Int(value)
        }
        
        return ver_int
    }
}

// MARK: - 富文本
public extension String {
    func getContentSize(_ font: UIFont, _ lineSpeace: CGFloat = 1.5, maxWidth: CGFloat) -> CGSize{
        let dic = [NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        
        let rect = (self as NSString).boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        return rect.size
    }
    
    func getContentWidth(_ font: UIFont, _ lineSpeace: CGFloat = 1.5, height: CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        
        let rect = (self as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        return rect.size.width
    }
    
    func getContentHeight(_ font: UIFont, _ lineSpeace: CGFloat = 1.5, width: CGFloat) -> CGFloat {
        let dic = [NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        
        let rect = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        return rect.size.height
    }
    
}

// MARK: - 进制转换
public extension String {
    func hexadecimal() -> Data? {
        var data = Data(capacity: self.count/2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }
    
    /// 有符号十进制转二进制
    func decTobin() -> String {
        var str = ""
        
        let convert: (UInt64) -> String = { value in
            var num = value
            var tStr = ""
            while num > 0 {
                tStr = "\(num % 2)" + tStr
                num /= 2
            }
            return tStr
        }
        
        if let num = Int64(self) {
            if num > 0 {
                str = convert(UInt64(num))
                return str
            } else {
                let num_abs = abs(num)
                if num_abs <= Int8.max {
                    let num_abs8: UInt8 = UInt8(num_abs)
                    let num_minus = ~num_abs8 + 1
                    str = convert(UInt64(num_minus))
                } else if num_abs <= Int16.max {
                    let num_abs16: UInt16 = UInt16(num_abs)
                    let num_minus = ~num_abs16 + 1
                    str = convert(UInt64(num_minus))
                } else if num_abs <= Int32.max {
                    let num_abs32: UInt32 = UInt32(num_abs)
                    let num_minus = ~num_abs32 + 1
                    str = convert(UInt64(num_minus))
                } else if num_abs <= Int64.max {
                    let num_abs64: UInt64 = UInt64(num_abs)
                    let num_minus = ~num_abs64 + 1
                    str = convert(UInt64(num_minus))
                }
               return str
            }
        }

        return str
    }

    /// 二进制转无符号十进制
    func binTodec() -> Int {
        var sum: Int = 0
        for c in self {
            let str = String(c)
            sum = sum * 2 + Int(str)!
        }
        return sum
    }

    /// 无符号十进制转十六进制
    func decTohex() -> String {
        return String(format: "%0X", self)
    }

    /// 无符号十六进制转十进制
    func hexTodec() -> Int {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
}

// MARK: - 截取插入
public extension String {
    /// 字符串任意位置插入
    ///
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 添加后的字符串
    func insert(_ content: String,locat: Int) -> String? {
        if locat <= 0 {
            return content + self
        } else if locat >= count {
            return self + content
        } else if let prefix = self[w: ..<locat],
           let suffix = self[w: locat...] {
            return prefix + content + suffix
        } else {
            return nil
        }
    }
}

// MARK: - Range
public extension String {
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
          return from ..< to
    }
}

// MARK: - 内容判断
public extension String {
    /// 是否为单个emoji表情
    var isSingleEmoji: Bool {
        return count==1&&containsEmoji
    }

    /// 包含emoji表情
    var containsEmoji: Bool {
        return contains{ $0.isEmoji}
    }

    /// 只包含emoji表情
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains{!$0.isEmoji}
    }

    /// 提取emoji表情字符串
    var emojiString: String {
        return emojis.map{String($0) }.reduce("",+)
    }

    /// 提取emoji表情数组
    var emojis: [Character] {
        return filter{ $0.isEmoji}
    }

    /// 提取单元编码标量
    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji}.flatMap{ $0.unicodeScalars}
    }
    
    /// 含有中文
    var containsChinese: Bool {
        var isContainChinese:Bool = false
        for i in 0..<Int(self.count){
            let c = NSString(string: self).character(at: i)
            if(c>0x4e00 && c < 0x9fa5) {
                isContainChinese = true
                break
            }
        }
        return isContainChinese
    }
}

// MARK: - URL
public extension String {
    
    /// 将原始的url编码为合法的url字符串
    public func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    
    /// 将编码后的url转换回原始的url字符串
    public func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    /// url合法化
    public func urlLegal() -> URL? {
        return URL(string: self.urlEncoded())
    }
}

public extension Character {
    /// 简单的emoji是一个标量，以emoji的形式呈现给用户
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        if #available(iOS 10.2, *) {
            return unicodeScalars.count > 0 &&
            (firstProperties.isEmojiPresentation ||
             firstProperties.generalCategory == .otherSymbol)
        } else {
            return unicodeScalars.count > 0 &&
            (firstProperties.generalCategory == .otherSymbol)
        }
                
    }

    /// 检查标量是否将合并到emoji中
    var isCombinedIntoEmoji: Bool {
        return unicodeScalars.count > 0 &&
            unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
    }

    /// 是否为emoji表情
    /// - Note: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    var isEmoji:Bool{
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}

extension NSAttributedString {
    func getContentSize(maxWidth: CGFloat) -> CGSize {
        return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).size
    }
    
    func getContentWidth(height: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, context: nil).size.width
    }
    
    func getContentHeight(width: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).size.height
    }
}
