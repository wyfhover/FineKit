//
//  DataExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import Foundation

public extension Data {
    
    /// Data转十六进制String
    /// - Parameter split: 每个byte的分隔符
    func hexadecimal(_ split: String = "") -> String {
        return map { String(format: "%02X", $0) }
                .joined(separator: split)
    }

}

public extension NSData {
    func getTarget(begin: Int, length: Int) -> NSData{
        if self.length < (begin + length){
            return NSData()
        }else{
            return self.subdata(with: NSMakeRange(begin, length)) as NSData
        }
    }
    func getLast(begin: Int) -> NSData {
        if self.length <= begin {
            return NSData()
        }else{
            return self.subdata(with: NSMakeRange(begin, self.length - begin)) as NSData
        }
    }
    
    func safeMemcpy(_ dst: UnsafeMutableRawPointer!, _ n: Int){
        if self.length >= n{
            memcpy(dst, self.bytes, n)
        }
        else{
            print("数据解析出错")
        }
    }
}
