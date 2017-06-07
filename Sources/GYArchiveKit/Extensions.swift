//
//  Extensions.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/5/25.
//
//

import Foundation
import PathKit

extension Path {
    // 路径中文件/文件夹的大小
    var size: Int {
        if isDirectory {
            let childrenPaths = try? children()
            return (childrenPaths ?? []).reduce(0){ $0 + $1.size }
        }else{
            // 隐藏文件
            if lastComponent.hasPrefix(".") { return 0 }
            let attr = try? FileManager.default.attributesOfItem(atPath: absolute().string)
            if let num = attr?[.size] as? NSNumber {
                return num.intValue
            }else {
                return 0
            }
        }
    }
    /// 获取工程名
    static func projectName(_ from: String) -> String? {
        guard let childPaths = try? Path(from).children() else { return nil }
        for childPath in childPaths {
            if childPath.isDirectory { continue }

            if childPath.string.hasSuffix(".xcworkspace") {
                return childPath.string.components(separatedBy: ".")[0]
            }else if childPath.string.hasSuffix(".xcodeproj") {
                return childPath.string.components(separatedBy: ".")[0]
            }
        }
        return nil
    }
}





