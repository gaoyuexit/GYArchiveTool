//
//  GYArchiveToolTests.swift
//  GYArchiveToolTests
//
//  Created by 郜宇 on 2017/6/7.
//
//

import XCTest

@testable import GYArchiveKit

class GYArchiveKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGYArchiveKitSpecs() {
        specGYArchiveKit()
    }
}
