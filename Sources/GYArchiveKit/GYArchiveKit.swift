//
//  GYArchiveKit.swift
//  GYArchiveTool
//
//  Created by 郜宇 on 2017/6/7.
//
//

import Foundation
import PathKit
import Rainbow


public struct Archive {
    
    public let log: Bool
    public let version: Bool
    public let upload: Bool
    public let commit: Bool
    public let fileProcess: FileProcess
    public let command: Command
    
    public init(fileProcess: FileProcess, log: String?, version: String?, upload: String?, commit: String?) throws {
        self.fileProcess = fileProcess
        self.command = Command(fileProcess: fileProcess)
        self.log = (log ?? "true") == "true" ? true : false
        self.version = (version ?? "true") == "true" ? true : false
        self.upload = (upload ?? "true") == "true" ? true : false
        self.commit = (commit ?? "true") == "true" ? true : false
    }
    
    public func execute() {
        print("Working...........".pass)
        
        showVersion()
        configExportOptionsPlist()
        fileProcess.buildNumberChange(.up)
        command.build()
        command.archive()
    }

    private func showVersion() {
        guard let info = fileProcess.readInfo() else {
            print("read info.plist version number error".error)
            return
        }
        print("current version number is \(info.versionNumber)  build number is \(info.buildNumber)".pass)

    }

    private func configExportOptionsPlist() {
        try? fileProcess.resultPath.delete()
        try? fileProcess.resultPath.mkpath()
        let p = NSMutableDictionary()
        p["method"] = "ad-hoc"
        p.write(toFile: fileProcess.exportOptionsPlistPath.string, atomically: true)
        print("--------- creat configExportOptionsPlist success -----------".pass)
    }
}







