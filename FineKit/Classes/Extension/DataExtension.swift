//
//  DataExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import Foundation

public extension FineKitWrapper where Base == Data {
    
    /// Data转十六进制String
    /// - Parameter split: 每个byte的分隔符
    func hexadecimal(_ split: String = "") -> String {
        return self.base.map { String(format: "%02X", $0) }.joined(separator: split)
    }
}

public extension FineKitWrapper where Base == NSData {
    func getTarget(begin: Int, length: Int) -> NSData {
        if self.base.length < (begin + length){
            return NSData()
        }else{
            return self.base.subdata(with: NSMakeRange(begin, length)) as NSData
        }
    }
    
    func getLast(begin: Int) -> NSData {
        if self.base.length <= begin {
            return NSData()
        }else{
            return self.base.subdata(with: NSMakeRange(begin, self.base.length - begin)) as NSData
        }
    }
    
    func safeMemcpy(_ dst: UnsafeMutableRawPointer!, _ n: Int){
        if self.base.length >= n{
            memcpy(dst, self.base.bytes, n)
        }
        else{
            print("数据解析出错")
        }
    }
}
