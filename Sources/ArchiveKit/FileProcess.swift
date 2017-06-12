//
//  FileProcess.swift
//  GYArchiveTool
//
//  Created by 郜宇 on 2017/6/8.
//
//

import Foundation
import PathKit

public enum FileError: Error {
    // 没有发现info.plist
    case noFindInfoPlist
    // 没有发现可执行的工程
    case noFindProject
}

public struct FileProcess {
    
    public typealias InfoNumber = (versionNumber: String, buildNumber: String)
    
    public enum Change: Int {
        case up = 1
        case down = -1
    }
    
    public let rootPath: Path
    public let resultPath: Path
    public let exportOptionsPlistPath: Path
    public let projectName: String
    public let infoPath: Path
    public let archivePath: Path
    public let workspacePath: Path
    public let ipaPath: Path
    
    
    public init(rootPathString: String, infoPath: String?) throws {
        
        self.rootPath = Path(rootPathString)
        self.resultPath = rootPath.parent() + "docs" + "Result"
        self.exportOptionsPlistPath = resultPath + "build.plist"
        guard let projectName = FileProcess.getProjectName(rootPathString) else { throw FileError.noFindProject }
        self.projectName = projectName
        
        self.archivePath = resultPath + "\(projectName).xcarchive"
        self.ipaPath = resultPath + "\(projectName).ipa"
        self.workspacePath = rootPath + "\(projectName).xcworkspace"
        
        if let infoPath = infoPath {
            self.infoPath = Path(infoPath)
        }else {
            guard let infoPath = FileProcess.getInfoPath(rootPathString, projectName: projectName) else { throw FileError.noFindInfoPlist }
            self.infoPath = infoPath
        }
        
        
    }
    
    /// 获取工程名
    static func getProjectName(_ from: String) -> String? {
        guard let childPaths = try? Path(from).children() else { return nil }
        for childPath in childPaths {
            if childPath.string.hasSuffix(".xcworkspace") {
                return childPath.lastComponentWithoutExtension
            }else if childPath.string.hasSuffix(".xcodeproj") {
                return childPath.lastComponentWithoutExtension
            }
        }
        return nil
    }
    /// 获取info.plist
    static func getInfoPath(_ from: String, projectName: String) -> Path? {
        let path = "\(from)/\(projectName)/\(projectName)/SupportingFiles/Info.plist"
        guard Path(path).exists else { return nil }
        return Path(path)
    }
    
    /// 读取info
    public func readInfo() -> InfoNumber? {
        guard let info = NSDictionary(contentsOfFile: infoPath.string) else { return nil }
        return (versionNumber: info["CFBundleShortVersionString"], buildNumber: info["CFBundleVersion"]) as? FileProcess.InfoNumber
    }
    
    public func buildNumberChange(_ c: Change) {
        guard let info = NSMutableDictionary(contentsOfFile: infoPath.string) else { return }
        let newbuild = Int(info["CFBundleVersion"] as! String)! + c.rawValue
        info["CFBundleVersion"] = newbuild.description
        info.write(toFile: infoPath.string, atomically: true)
        print("------------------ Update buildNumber to \(newbuild) ------------------".pass)
    }
}







