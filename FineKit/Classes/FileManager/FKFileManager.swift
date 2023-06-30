//
//  沙盒文件管理
//  FKFileManager
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

fileprivate let DocumentsPath = NSHomeDirectory() + "/Documents/"
fileprivate let FirmwarePath = DocumentsPath + "Firmware/"
fileprivate let IconPath = DocumentsPath + "Icon/"
fileprivate let GifPath = DocumentsPath + "Gif/"
fileprivate let AudioPath = DocumentsPath + "Audio/"
fileprivate let RestorePath = DocumentsPath + "Restore/"

public enum FKFilePath {
    case document
    case firmware
    case icon
    case gif
    case audio
    case restore
    
    func getPath() -> String {
        switch self {
        case .document:
            return DocumentsPath
        case .firmware:
            return FirmwarePath
        case .icon:
            return IconPath
        case .gif:
            return GifPath
        case .audio:
            return AudioPath
        case .restore:
            return RestorePath
        }
    }
}

public class FKFileManager {
    public static let shared = FKFileManager()
   
    private let fileQueue = DispatchQueue(label: "com.fileManager", qos: .default, attributes: .concurrent)
    
    private init() {}
    
    public func save(fileName: String, data: Data, path: FKFilePath, complete: ((Bool) -> Void)? = nil) {
        let targetPath = path.getPath() + self.tranform(fileName: fileName)
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
    
    func copy(path: String, fileName: String, to toPath: FKFilePath, complete: ((Bool) -> Void)? = nil) {
        let targetPath = toPath.getPath() + self.tranform(fileName: fileName)
        let kUrl = URL(fileURLWithPath: targetPath)
        
        guard let pathUrl = URL(string: path) else {
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
    
    public func read(fileName: String, from path: FKFilePath, callback: @escaping (Data?) -> Void) {
        self.fileQueue.async {
            let targetPath = path.getPath() + self.tranform(fileName: fileName)
            let data = self.loadDataToPath(targetPath)
            callback(data)
        }
    }
    
    public func delete(fileName: String, from path: FKFilePath, callback: ((Bool) -> Void)? = nil) {
        self.fileQueue.async(group: nil, qos: .default, flags: .barrier) {
            let targetPath = path.getPath() + self.tranform(fileName: fileName)
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
        return from.getPath() + self.tranform(fileName: (name ?? ""))
    }
    
    public func checkFileExists(name: String, from path: FKFilePath) -> Bool {
        let targetPath = path.getPath() + self.tranform(fileName: name)
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
    
    fileprivate func deleteDataToPath(_ path: String){
        try? FileManager.default.removeItem(atPath: path)
    }
    
}

