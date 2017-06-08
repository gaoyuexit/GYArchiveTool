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
@testable import GYArchiveKit

public func specGYArchiveKit() {

    let fixtures = Path(#file).parent().parent() + "Fixture"
    let projectPath = fixtures + "iOS"
    
    describe("specGYArchiveKit") {
        $0.it("get projectName"){
            
            let file = File(projectPathString: projectPath.string)

            try expect(file.projectName) == "MaiDou"
            try expect(file.infoPath) == Path("\(projectPath.string)/MaiDou/MaiDou/SupportingFiles/Info.plist")
        }
        
        $0.it("get infoNumber") {
            
            let file = File(projectPathString: projectPath.string)
    
            try expect(file.readInfo()?.versionNumber) == "1.2.1"
            try expect(file.readInfo()?.buildNumber) == "50"
        }
        
        $0.it("config exportOptionsPlist") {
            
            let tool = try? Archive(projectPath: projectPath.string, log: nil, version: nil, upload: nil, commit: nil, infoPath: nil)
            tool?.execute()
        }
        
    }
}
