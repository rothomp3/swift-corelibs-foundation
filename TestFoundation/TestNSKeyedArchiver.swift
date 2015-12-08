// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


#if DEPLOYMENT_RUNTIME_OBJC || os(Linux)
    import Foundation
    import XCTest
#else
    @testable import SwiftFoundation
    import SwiftXCTest
#endif

import CoreFoundation

class TestNSKeyedArchiver: XCTestCase {
    func test_SetClassForName() {
        NSKeyedArchiver.setClassName("Blorfle", forClass: NSObject.self)
        XCTAssert(NSKeyedArchiver.classNameForClass(NSObject.self) == "Blorfle")
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.setClassName("Foo", forClass: NSArray.self)
        XCTAssert(archiver.classNameForClass(NSArray.self) == "Foo")
        XCTAssert(archiver.classNameForClass(NSObject.self) == "Blorfle")
    }
    
    func test_BasicConstruction() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.outputFormat = .XMLFormat_v1_0
        
        let dict = archiver._rootDict
        for (key, value) in dict {
            print("\(key): \(value)")
        }
        
        archiver.encodeBytes("Hello there", length: 12, forKey: "theAnswer")
        archiver.finishEncoding()
        
        let result = NSString(data: data, encoding: NSUTF8StringEncoding)
        print(result?._swiftObject)
        
        data.writeToFile("/Users/robert/Library/Containers/com.apple.dt.playground.stub.OSX.FoundationPlayground-926378D7-E915-4B59-BBC4-D06AF6745232/Data/Documents/testnewFoundation.plist", atomically: false)
    }
    
    var allTests: [(String, () -> ())] {
        return [
            ("test_SetClassForName", test_SetClassForName),
            ("test_BasicSetup", test_BasicConstruction)
        ]
    }
}
