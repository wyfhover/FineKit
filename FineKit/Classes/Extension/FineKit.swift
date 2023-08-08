//
//  FineKit.swift
//  FineKit
//
//  Created by Fine on 2023/7/7.
//

import Foundation

public protocol FineKitCompatible: Any { }

public struct FineKitWrapper<Base> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension FineKitCompatible {
    static var fk: FineKitWrapper<Self.Type> {
        get { return FineKitWrapper(Self.self) }
        set { }
    }
    
    var fk: FineKitWrapper<Self> {
        get { return FineKitWrapper(self) }
        set { }
    }
}

// MARK: - 结构体
extension Array: FineKitCompatible {}
extension Data: FineKitCompatible {}
extension String: FineKitCompatible {}
extension Character: FineKitCompatible {}

// MARK: - 类
//extension UIButton: FineKitCompatible {}
extension UIColor: FineKitCompatible {}
extension UIDevice: FineKitCompatible {}
extension UIImage: FineKitCompatible {}
//extension UILabel: FineKitCompatible {}
extension UIViewController: FineKitCompatible {}
extension UIView: FineKitCompatible {}

extension NSData: FineKitCompatible {}

// MARK: - 协议
extension BinaryFloatingPoint {
    public var fk: FineKitWrapper<Self> {
        get { return FineKitWrapper(self) }
        set { }
    }
}

extension FixedWidthInteger {
    public var fk: FineKitWrapper<Self> {
        get { return FineKitWrapper(self) }
        set { }
    }
}

