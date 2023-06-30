//
//  BinaryFloatingPointExtension.swift
//  Extension
//
//  Created by Fine on 2023/6/14.
//  Copyright © 2023 Fine. All rights reserved.
//

import Foundation

public extension BinaryFloatingPoint {
    
    /// 浮点型转byte数组
    func toBytes() -> [UInt8] {
        var value = self
        let size = MemoryLayout<Self>.size
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: size) {
                Array(UnsafeBufferPointer(start: $0, count: size))
            }
        }.reversed()
    }
}
