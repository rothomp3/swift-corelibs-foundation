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



class TestNSXMLDocument : XCTestCase {
    
    var allTests: [(String, () -> Void)] {
        return [
            ("test_basicCreation", test_basicCreation),
            ("test_xpath", test_xpath)
        ]
    }
    
    func test_basicCreation() {
        let doc = NSXMLDocument(rootElement: nil)
        XCTAssert(doc.version == "1.0", "expected 1.0, got \(doc.version)")
        doc.version = "1.1"
        XCTAssert(doc.version == "1.1", "expected 1.1, got \(doc.version)")
        let node = NSXMLElement(name: "Hello", URI: "http://www.example.com")

        let fooNode = NSXMLElement(name: "Foo")
        let barNode = NSXMLElement(name: "msxml:Bar")
        let bazNode = NSXMLElement(name: "Baz")
       
        doc.setRootElement(node)
        
        let element = doc.rootElement()!
        element.addChild(fooNode)
        fooNode.addChild(bazNode)
        element.addChild(barNode)
//        doc.setRootElement(element)
        
        print("RootDocument:\n\(element.rootDocument?.description ?? "")")
        
        print(doc.rootElement()?.name ?? "")
        
        print(doc.nextNode)
        print(doc.nextNode?.nextNode)
        print(doc.nextNode?.nextNode?.nextNode)
        print(doc.nextNode?.nextNode?.nextNode?.nextNode)
        print(doc.nextNode?.nextNode?.nextNode?.nextNode?.nextNode)
        
        print(barNode)
        print(barNode.previousNode)
        print(barNode.previousNode?.previousNode)
        print(barNode.previousNode?.previousNode?.previousNode)
        print(barNode.previousNode?.previousNode?.previousNode?.previousNode)
        
        print(barNode.prefix)
        print(fooNode.prefix)
    }
}

func test_xpath() {
    let doc = NSXMLDocument(rootElement: nil)
    let foo = NSXMLElement(name: "foo")
    let bar1 = NSXMLElement(name: "bar")
    let bar2 = NSXMLElement(name: "bar")
    let bar3 = NSXMLElement(name: "bar")
    let baz = NSXMLElement(name: "baz")
    
    doc.setRootElement(foo)
    foo.addChild(bar1)
    foo.addChild(bar2)
    foo.addChild(bar3)
    bar2.addChild(baz)
    
    XCTAssertEqual(baz.XPath, "foo/bar[2]/baz")
    
    let baz2 = NSXMLElement(name: "baz")
    bar2.addChild(baz2)
    
    XCTAssertEqual(baz.XPath, "foo/bar[2]/baz[1]")
    XCTAssertEqual(try! doc.nodesForXPath(baz.XPath!).first, baz)
    
    let nodes = try! doc.nodesForXPath("foo/bar")
    XCTAssertEqual(nodes.count, 3)
    XCTAssertEqual(nodes[0], bar1)
    XCTAssertEqual(nodes[1], bar2)
    XCTAssertEqual(nodes[2], bar3)
}

func contents(ptr: UnsafePointer<Void>, _ length: Int) -> String {
    let wordPtr = UnsafePointer<UInt>(ptr)
    let words = length / sizeof(UInt.self)
    let wordChars = sizeof(UInt.self) * 2
    
    let buffer = UnsafeBufferPointer<UInt>(start: wordPtr, count: words)
    let wordStrings = buffer.map({ word -> String in
        var wordString = String(word, radix: 16)
        while wordString.characters.count < wordChars {
            wordString = "0" + wordString
        }
        return wordString
    })
    return wordStrings.joinWithSeparator(" ")
}