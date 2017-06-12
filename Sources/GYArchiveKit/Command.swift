//
//  Commend.swift
//  GYArchiveTool
//
//  Created by 郜宇 on 2017/6/11.
//
//

import Foundation
import PathKit

public struct Command {
    
    let fileProcess: FileProcess
    
    public init(fileProcess: FileProcess) {
        self.fileProcess = fileProcess
    }
    
    public func build() {
        let p = Process()
        p.launchPath = "/usr/bin/xcodebuild"
        var args = [String]()
        args.append("xcodebuild")
        args.append("-workspace")
        args.append("\(fileProcess.workspacePath.string)")
        args.append("-scheme")
        args.append("\(fileProcess.projectName)")
        args.append("clean")
        args.append("archive")
        args.append("-archivePath")
        args.append("\(fileProcess.archivePath.string)")
        p.arguments = args
        p.launch()
        print("Excusing ->" + "\(args)" + "<- Commond\n".pass)
    }
    
    public func archive() {
        print("------------------Start Archive---------------------\n".pass)
        let p = Process()
        p.launchPath = "/usr/bin/xcodebuild"
        var args = [String]()
        args.append("xcodebuild")
        args.append("-exportArchive")
        args.append("-archivePath")
        args.append("\(fileProcess.archivePath.string)")
        args.append("-exportPath")
        args.append("\(fileProcess.resultPath.string)")
        args.append("-exportOptionsPlist")
        args.append("\(fileProcess.exportOptionsPlistPath.string)")
        p.arguments = args
        p.launch()
        print("Excusing ->" + "\(args)" + "<- Commond\n".pass)
    }
    
}
