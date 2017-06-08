//
//  FileProcess.swift
//  GYArchiveTool
//
//  Created by 郜宇 on 2017/6/8.
//
//

import Foundation
import PathKit

public struct File {
    
    public typealias InfoNumber = (versionNumber: String, buildNumber: String)
    
    public enum Change: Int {
        case up = 1
        case down = -1
    }
    
    public let projectPath: Path
    public let resultPath: Path
    public let exportOptionsPlistPath: Path
    public var projectName: String?
    public var infoPath: Path?
    
    public init(projectPathString: String) {
        self.projectPath = Path(projectPathString)
        self.resultPath = projectPath.parent() + "docs" + "Result"
        self.exportOptionsPlistPath = resultPath + "build.plist"
        projectName = projectName(projectPathString)
        infoPath = infoPath(projectPathString)
    }
    
    /// 获取工程名
    private func projectName(_ from: String) -> String? {
        guard let childPaths = try? Path(from).children() else { return nil }
        for childPath in childPaths {
            if childPath.isDirectory { continue }
            if childPath.string.hasSuffix(".xcworkspace") {
                return childPath.lastComponentWithoutExtension
            }else if childPath.string.hasSuffix(".xcodeproj") {
                return childPath.lastComponentWithoutExtension
            }
        }
        return nil
    }
    /// 获取info.plist
    private func infoPath(_ from: String) -> Path? {
        guard let projectName = projectName else { return nil }
        let path = "\(from)/\(projectName)/\(projectName)/SupportingFiles/Info.plist"
        return Path(path)
    }
    
    /// 读取info
    public func readInfo() -> InfoNumber? {
        guard let infoPath = infoPath else { return nil }
        guard let info = NSDictionary(contentsOfFile: infoPath.string) else { return nil }
        return (versionNumber: info["CFBundleShortVersionString"], buildNumber: info["CFBundleVersion"]) as? File.InfoNumber
    }
    
    public func buildNumberChange(_ c: Change) {
        guard let infoPath = infoPath else { return }
        guard let info = NSMutableDictionary(contentsOfFile: infoPath.string) else { return }
        info["CFBundleVersion"] = (info["CFBundleVersion"] as! Int) + c.rawValue
        info.write(toFile: infoPath.string, atomically: true)
    }
}
