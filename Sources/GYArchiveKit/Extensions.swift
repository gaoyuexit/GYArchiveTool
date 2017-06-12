//
//  Extensions.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/5/25.
//
//

import Foundation
import PathKit
import Rainbow

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
}

public extension String {
    var error: String { return self.red.bold }
    var pass: String { return self.green.bold }
}

public extension Process {
    
    func execute(args: [String]) {
        arguments = args
        launch()
        print(("Excusing ->" + "\(args)" + "<- Commond\n").pass)
        waitUntilExit()
    }
}








