//
//  CollectionExtension.swift
//  Extension
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import Foundation

//public extension Collection {
public extension FineKitWrapper where Base: Collection {
    /// 下标取值
    subscript(index: Int ) -> Base.Element? {
        let tIndex = self.base.index(self.base.startIndex, offsetBy: index)
        return (self.base.startIndex ..< self.base.endIndex).contains(tIndex) ? self.base[tIndex] : nil
    }
    
    /// 根据range获取子集 a[1...3]
    subscript(r: ClosedRange<Int>) -> Base.SubSequence? {
        guard r.lowerBound <= r.upperBound else { return nil }
        guard r.lowerBound < self.base.count && r.upperBound < self.base.count else { return nil }
        let start = self.base.index(self.base.startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = self.base.index(self.base.startIndex, offsetBy: Swift.min(r.upperBound, self.base.count - 1))
        return self.base[start...end]
    }
    
    /// 根据range获取子集 a[0..<2]
    subscript(r: Range<Int>) -> Base.SubSequence? {
        guard r.lowerBound < r.upperBound else { return nil } //[1..<1] 返回“”
        guard r.lowerBound < self.base.count && r.upperBound <= self.base.count else { return nil }
        let start = self.base.index(self.base.startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = self.base.index(self.base.startIndex, offsetBy: Swift.min(r.upperBound, self.base.count))
        return self.base[start..<end]
    }
    
    /// 根据range获取子集 a[...2]
    subscript(r: PartialRangeThrough<Int>) -> Base.SubSequence? {
        guard r.upperBound >= 0 else { return nil }
        let end = self.base.index(self.base.startIndex, offsetBy: Swift.min(r.upperBound, self.base.count - 1))
        return self.base[self.base.startIndex...end]
    }
    /// 根据range获取子集 a[0...]
    subscript(r: PartialRangeFrom<Int>) -> Base.SubSequence? {
        guard r.lowerBound < self.base.count else { return nil }
        let start = self.base.index(self.base.startIndex, offsetBy: Swift.max(r.lowerBound, 0))
        let end = self.base.index(self.base.startIndex, offsetBy: self.base.count - 1)
        return self.base[start...end]
    }
    /// 根据range获取子集 a[..<3]
    subscript(r: PartialRangeUpTo<Int>) -> Base.SubSequence? {
        guard r.upperBound <= self.base.count && r.upperBound > 0 else { return nil } // [..<0] 返回“”
        let end = self.base.index(self.base.startIndex, offsetBy: Swift.min(r.upperBound, self.base.count))
        return self.base[self.base.startIndex..<end]
    }
}
