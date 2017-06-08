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

public enum ArchiveError: Error {
    // 没有发现info.plist
    case noFindInfoPlist
    // 没有发现可执行的工程
    case noFindProject
}



public struct Archive {
    
    public let projectPath: String
    public let log: Bool
    public let version: Bool
    public let upload: Bool
    public let commit: Bool
    public let infoPath: String
    
    public let fileHandle: File
    
    public init(projectPath: String?, log: String?, version: String?, upload: String?, commit: String?, infoPath: String?) throws {
        fileHandle = File(projectPathString: projectPath ?? ".")
        self.projectPath = projectPath ?? "."
        self.log = (log ?? "true") == "true" ? true : false
        self.version = (version ?? "true") == "true" ? true : false
        self.upload = (upload ?? "true") == "true" ? true : false
        self.commit = (commit ?? "true") == "true" ? true : false
    
        if let infoPath = infoPath {
            self.infoPath = infoPath
        }else{
            guard let infoPath = fileHandle.infoPath?.string else {
                throw ArchiveError.noFindInfoPlist
            }
            self.infoPath = infoPath
        }
        if fileHandle.projectName == nil { throw ArchiveError.noFindProject }
    }
    
    public func execute() {
        print("Working...........".pass)
        
        showVersion()
        configExportOptionsPlist()
        fileHandle.buildNumberChange(.up)
        
    }
    
    private func showVersion() {
        guard let info = fileHandle.readInfo() else {
            print("read info.plist version number error".error)
            return
        }
        print("current version number is \(info.versionNumber)  build number is \(info.buildNumber)".pass)

    }
    
    private func configExportOptionsPlist() {
        try? fileHandle.resultPath.delete()
        try? fileHandle.resultPath.mkpath()
        let p = NSMutableDictionary()
        p["method"] = "ad-hoc"
        p.write(toFile: fileHandle.exportOptionsPlistPath.string, atomically: true)
        print("configExportOptionsPlist success".pass)
    }
}







