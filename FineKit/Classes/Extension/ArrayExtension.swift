//
//  ArrayExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

public extension FineKitWrapper where Base == Array<Any> {
    
    mutating func popFirst() -> Base.Element? {
        if self.base.count > 0 {
            return self.base.removeFirst()
        } else {
            return nil
        }
    }
    
    mutating func pop(index: Int) -> Base.Element? {
        if !self.base.isEmpty && index < self.base.count {
            return self.base.remove(at: index)
        } else {
            return nil
        }
    }
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Base.Element) -> E) -> [Base.Element] {
        var result = [Base.Element]()
        for value in self.base {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

public extension FineKitWrapper where Base == Array<UInt8> {
    /// 16进制字符
    var hexString: String {
        get {
            return self.base.compactMap { String(format: "%02x", $0).uppercased() }
            .joined(separator: "")
        }
    }
    
    /// byte数组转换成 FixedWidthInteger
    /// - Parameter type: FixedWidthInteger 类型 例：8-64位整型 Uint8 Uint64
    func to<T>(type: T.Type) -> T where T: FixedWidthInteger {
        let size = type.bitWidth / 8
        var target: T = 0
        var ary = self.base
        
        while ary.count < size {
            ary.insert(0, at: 0)
        }
        
        let data = NSData(bytes: ary.reversed(), length: ary.count)
        
        data.getBytes(&target, length: ary.count)
        
        return target
    }
    
    /// byte数组转换成 BinaryFloatingPoint
    /// - Parameter type: 浮点BinaryFloatingPoint类型 例：Float Double
    func to<T>(type: T.Type) -> T where T: BinaryFloatingPoint {
        var target: T = 0.0

        memcpy(&target, self.base.reversed(), self.base.count) // reversed大端转小端
        return target
    }
}
