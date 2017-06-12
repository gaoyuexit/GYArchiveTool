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
    
    public func archive() {
        print("------------------ Start Archive ---------------------\n".pass)
        let p = Process()
        p.launchPath = "/usr/bin/xcodebuild"
        var args = [String]()
        args.append("-workspace")
        args.append("\(fileProcess.workspacePath.string)")
        args.append("-scheme")
        args.append("\(fileProcess.projectName)")
        args.append("clean")
        args.append("archive")
        args.append("-archivePath")
        args.append("\(fileProcess.archivePath.string)")
        p.execute(args: args)
    }
    
    public func export() {
        print("------------------ Start Export ---------------------\n".pass)
        let p = Process()
        p.launchPath = "/usr/bin/xcodebuild"
        var args = [String]()
        args.append("-exportArchive")
        args.append("-archivePath")
        args.append("\(fileProcess.archivePath.string)")
        args.append("-exportPath")
        args.append("\(fileProcess.resultPath.string)")
        args.append("-exportOptionsPlist")
        args.append("\(fileProcess.exportOptionsPlistPath.string)")
        p.execute(args: args)
        let size = Double(fileProcess.ipaPath.size) / 1000 / 1000
        print("------------------ export ipa size: \(String(format: "%.1f M", size)) ---------------------\n".pass)
    }
    
    public func upload(log: String) {
        print("------------------ Start Upload to Fir ---------------------\n".pass)
        let firPath = "/usr/local/bin/fir"
        let p = Process()
         p.launchPath = firPath
        var args = [String]()
        args.append("p")
        args.append("\(fileProcess.ipaPath.string)")
        args.append("-c")
        args.append("\(log)")
        p.execute(args: args)
    }
    
    public func commit() {
        guard let info = fileProcess.readInfo() else { return }
        let p = Process()
        p.launchPath = "/usr/bin/git"
        var args = [String]()
        args.append("commit")
        args.append("-am")
        args.append("New Packet: \(info.versionNumber) \(info.buildNumber)")
        p.execute(args: args)
    }
    public func push() {
        let p = Process()
        p.launchPath = "/usr/bin/git"
        var args = [String]()
        args.append("push")
        p.execute(args: args)
    }
}
