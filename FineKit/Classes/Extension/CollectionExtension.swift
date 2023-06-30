//
//  CollectionExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import Foundation

public extension Collection {
    /// 下标取值
    subscript(w index: Int ) -> Element? {
        let tIndex = self.index(self.startIndex, offsetBy: index)
        return (self.startIndex ..< self.endIndex).contains(tIndex) ? self[tIndex] : nil
    }
    
    /// 根据range获取子集 a[1...3]
    subscript(w r: ClosedRange<Int>) -> Self.SubSequence? {
        guard r.lowerBound <= r.upperBound else { return nil }
        guard r.lowerBound < count && r.upperBound < count else { return nil }
        let start = index(self.startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: Swift.min(r.upperBound, count - 1))
        return self[start...end]
    }
    
    /// 根据range获取子集 a[0..<2]
    subscript(w r: Range<Int>) -> Self.SubSequence? {
        guard r.lowerBound < r.upperBound else { return nil } //[1..<1] 返回“”
        guard r.lowerBound < count && r.upperBound <= count else { return nil }
        let start = index(startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: Swift.min(r.upperBound, count))
        return self[start..<end]
    }
    
    /// 根据range获取子集 a[...2]
    subscript(w r: PartialRangeThrough<Int>) -> Self.SubSequence? {
        guard r.upperBound >= 0 else { return nil }
        let end = index(startIndex, offsetBy: Swift.min(r.upperBound, count - 1))
        return self[startIndex...end]
    }
    /// 根据range获取子集 a[0...]
    subscript(w r: PartialRangeFrom<Int>) -> Self.SubSequence? {
        guard r.lowerBound < count else { return nil }
        let start = index(startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = index(startIndex, offsetBy: count - 1)
        return self[start...end]
    }
    /// 根据range获取子集 a[..<3]
    subscript(w r: PartialRangeUpTo<Int>) -> Self.SubSequence? {
        guard r.upperBound <= count && r.upperBound > 0 else { return nil } // [..<0] 返回“”
        let end = index(startIndex, offsetBy: Swift.min(r.upperBound, count))
        return self[startIndex..<end]
    }
}
