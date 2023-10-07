//
//  沙盒文件管理
//  FKFileManager
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

fileprivate let HomePath = NSHomeDirectory()
fileprivate let DocumentsPath = HomePath.appending("/Documents")
fileprivate let TempPath = NSTemporaryDirectory()

public enum FKFilePath {
    case home(path: String)
    case document(path: String)
    case temp(path: String)
    
    func getPath() -> String {
        switch self {
        case let .home(path):
            return HomePath.appending(path.file)
        case let .document(path):
            return DocumentsPath.appending(path.file)
        case let .temp(path):
            return TempPath.appending(path)
        }
    }
}

public class FKFileManager {
    public static let shared = FKFileManager()
   
    private let fileQueue = DispatchQueue(label: "com.fileManager", qos: .default, attributes: .concurrent)
    
    private init() {}
    
    /// 保存
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - data: 二进制数据
    ///   - path: 文件夹路径
    public func save(fileName: String, data: Data, path: FKFilePath, complete: ((Bool) -> Void)? = nil) {
        let targetPath = path.getPath().appending(self.tranform(fileName: fileName).file)
        let kUrl = URL(fileURLWithPath: targetPath)
        
        self.fileQueue.async(group: nil, qos: .default, flags: .barrier) { [weak self] in
            if !FileManager.default.fileExists(atPath: path.getPath()) { // 文件夹是否存在
                do {
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: path.getPath()), withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("FKFileManager create file name:\(fileName), path:\(targetPath), dataCount:\(data.count) error:\(error)")
                    complete?(false)
                }
            }
            
            if FileManager.default.fileExists(atPath: targetPath) { //检查文件夹中目标文件是否存在
                self?.deleteDataToPath(targetPath)
            }
            
            do {
                try data.write(to: kUrl)
                complete?(true)
            } catch {
                print("FKFileManager write file name:\(fileName), path:\(targetPath), dataCount:\(data.count) error:\(error)")
                complete?(false)
            }
        }
    }
    
    /// 拷贝文件到新路径
    /// - Parameters:
    ///   - path: 旧文件路径
    ///   - fileName: 旧文件名
    ///   - toPath: 新文件路径
    func copy(path: String, fileName: String, to toPath: FKFilePath, complete: ((Bool) -> Void)? = nil) {
        let targetPath = toPath.getPath().appending(self.tranform(fileName: fileName).file)
        
        guard URL(string: path) != nil else {
            complete?(false)
            return
        }
        
        self.fileQueue.async(group: nil, qos: .default, flags: .barrier) {
            do {
//                try FileManager.default.copyItem(at: pathUrl, to: kUrl)
                try FileManager.default.copyItem(atPath: path, toPath: targetPath)
                complete?(true)
            } catch {
                print("FKFileManager copy file name:\(fileName), from:\(path), to:\(targetPath) error:\(error)")
                complete?(false)
            }
        }
    }
    
    /// 读取
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - path: 文件路径
    public func read(fileName: String, from path: FKFilePath, callback: @escaping (Data?) -> Void) {
        self.fileQueue.async {
            let targetPath = path.getPath().appending(self.tranform(fileName: fileName).file)
            let data = self.loadDataToPath(targetPath)
            callback(data)
        }
    }
    
    /// 删除
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - path: 文件路径
    public func delete(fileName: String, from path: FKFilePath, callback: ((Bool) -> Void)? = nil) {
        self.fileQueue.async(group: nil, qos: .default, flags: .barrier) {
            let targetPath = path.getPath().appending(self.tranform(fileName: fileName))
            if FileManager.default.fileExists(atPath: targetPath) { //检查文件夹中目标文件是否存在
                self.deleteDataToPath(targetPath)
                callback?(true)
            } else {
                callback?(false)
            }
        }
    }
    
    /// 获取路径名字
    /// - Parameters:
    ///   - from: 文件类型
    ///   - name: 文件名
    public func getPath(from: FKFilePath, with name: String? = nil) -> String {
        if let name = name, !name.isEmpty {
            return from.getPath().appending(self.tranform(fileName: name).file)
        } else {
            return from.getPath()
        }
    }
    
    /// 获取路径URL
    /// - Parameters:
    ///   - from: 文件路径
    ///   - name: 文件名
    public func getPathUrl(from: FKFilePath, with name: String? = nil) -> URL {
        let path = self.getPath(from: from, with: name)
        return URL(fileURLWithPath: path)
    }
    
    public func checkFileExists(name: String, from path: FKFilePath) -> Bool {
        let targetPath = path.getPath().appending(self.tranform(fileName: name).file)
        return FileManager.default.fileExists(atPath: targetPath)
    }
    
    private func tranform(fileName: String) -> String {
        var realName = fileName
        if realName.contains("/") {
            realName = realName.split(separator: "/").joined(separator: "-")
        }
        return realName
    }
    
    private func loadDataToPath(_ path: String)-> Data?{
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        return data
    }
    
    private func loadDataToPath(_ path: URL)-> Data?{
//        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: path)
        return data
    }
    
    fileprivate func deleteDataToPath(_ path: String){
        try? FileManager.default.removeItem(atPath: path)
    }
    
}

fileprivate extension String {
    var file: String {
        return String(format: "/%@", self)
    }
}

