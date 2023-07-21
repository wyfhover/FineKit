//
//  FixedWidthIntegerExtension.swift
//  Extension
//
//  Created by Fine on 2023/6/14.
//  Copyright © 2023 Fine. All rights reserved.
//

import Foundation

public extension FineKitWrapper where Base: FixedWidthInteger {
        
    func toBytes() -> [UInt8] {
        let size = self.base.bitWidth / 8
        var bytes: [UInt8] = []
        
        for idx in 0 ..< size {
            if idx == size - 1, let _ = self.base as? (any SignedInteger) {
                bytes.insert(UInt8((self.base >> (idx * 8)) & 0x7F) , at: 0)
            } else {
                bytes.insert(UInt8((self.base >> (idx * 8)) & 0xFF) , at: 0)
            }
        }
        
        return bytes
    }
    
    /// 类型转换
    /// - Parameter type: FixedWidthInteger类型
    func to<T>(type: T.Type) -> T where T: FixedWidthInteger {
        let size = type.bitWidth / 8
        var target: T = 0
        var ary = self.toBytes()
        
        while ary.count < size {
            ary.insert(0, at: 0)
        }
        
        let data = NSData(bytes: ary.reversed(), length: ary.count)
        
        data.getBytes(&target, length: ary.count)
        
        return target
    }
    
}
