//
//  NSObjectTests.swift
//  Rex
//
//  Created by Neil Pankey on 5/28/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import Rex
import ReactiveSwift
import XCTest
import enum Result.NoError

final class NSObjectTests: XCTestCase {
    
    func testProducerForKeyPath() {
        let object = Object()
        var value: String = ""

        object.reactive.values(forKeyPath: "string").startWithValues { value = $0 as! String }
        XCTAssertEqual(value, "foo")

        object.string = "bar"
        XCTAssertEqual(value, "bar")
    }
    
    func testObjectsWillBeDeallocatedSignal() {
        
        let expectation = self.expectation(description: "Expected timer to send `completed` event when object deallocates")
        defer { self.waitForExpectations(timeout: 2, handler: nil) }
        
        let object = Object()

        timer(interval: 1, on: QueueScheduler(name: "test.queue"))
            .take(until: object.reactive.lifetime.ended)
            .startWithCompleted {
                expectation.fulfill()
        }
    }
}

final class NSObjectDeallocTests: XCTestCase {

    weak var _object: Object?

    override func tearDown() {
        XCTAssert(_object == nil, "Retain cycle detected")
        super.tearDown()
    }

    func testStringPropertyDoesntCreateRetainCycle() {
        let object = Object()
        _object = object

        associatedProperty(object, keyPath: "string") <~ SignalProducer(value: "Test")
        XCTAssert(_object?.string == "Test")
    }

    func testClassPropertyDoesntCreateRetainCycle() {
        let object = Object()
        _object = object
        associatedProperty(object, keyPath: "string", placeholder: { "Test"} ) <~ SignalProducer(value: "Test")
        XCTAssert(_object?.string == "Test")
    }
}

class Object: NSObject {
    dynamic var string = "foo"
}
