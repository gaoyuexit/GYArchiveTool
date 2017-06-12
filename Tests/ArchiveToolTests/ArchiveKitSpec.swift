//
//  GYArchiveKitSpec.swift
//  GYArchiveTool
//
//  Created by 郜宇 on 2017/6/7.
//
//

import Foundation

import Spectre
import PathKit
@testable import ArchiveKit

public func specArchiveKit() {

    let fixtures = Path(#file).parent().parent() + "Fixture"
    let rootPath = fixtures + "iOS"
    
    describe("specGYArchiveKit") {
        $0.it("get projectName"){
            
            let file = try! FileProcess(rootPathString: rootPath.string, infoPath: nil)

            try expect(file.projectName) == "MaiDou"
            try expect(file.infoPath) == Path("\(rootPath.string)/MaiDou/MaiDou/SupportingFiles/Info.plist")
        }
        
        $0.it("get infoNumber") {
            
            let file = try! FileProcess(rootPathString: rootPath.string, infoPath: nil)
    
            try expect(file.readInfo()?.versionNumber) == "1.2.1"
            try expect(file.readInfo()?.buildNumber) == "50"
        }
        
        $0.it("config exportOptionsPlist") {
            
            let file = try! FileProcess(rootPathString: rootPath.string, infoPath: nil)
            let tool = try! Archive(fileProcess: file, log: nil, version: nil, upload: nil, commit: nil)
            
            tool.execute()
        }
        
    }
}
