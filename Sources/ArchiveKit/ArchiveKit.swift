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
    
    public let log: String
    public let version: Bool
    public let upload: Bool
    public let commit: Bool
    public let fileProcess: FileProcess
    public let command: Command
    
    public init(fileProcess: FileProcess, log: String?, version: Bool, upload: Bool, commit: Bool) throws {
        self.fileProcess = fileProcess
        self.command = Command(fileProcess: fileProcess)
        self.log = log ?? ""
        self.version = !version
        self.upload = !upload
        self.commit = !commit
    }
    
    public func execute() {
        print("Working...".tip.pass)
        showVersion()
        configExportOptionsPlist()
        if version { fileProcess.buildNumberChange(.up) }
        command.archive()
        command.export()
        if upload { command.upload(log: log) }
        if commit { command.commit(); command.push() }
    }

    private func showVersion() {
        guard let info = fileProcess.readInfo() else {
            print("read info.plist version number error".tip.error)
            return
        }
        print("current version number is \(info.versionNumber)  build number is \(info.buildNumber)".tip.pass)
    }

    private func configExportOptionsPlist() {
        try? fileProcess.resultPath.delete()
        try? fileProcess.resultPath.mkpath()
        let p = NSMutableDictionary()
        p["method"] = "ad-hoc"
        p.write(toFile: fileProcess.exportOptionsPlistPath.string, atomically: true)
        print("creat configExportOptionsPlist success".tip.pass)
    }
}







