//
//  SignalTests.swift
//  Rex
//
//  Created by Neil Pankey on 5/9/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

@testable import Rex
import ReactiveCocoa
import XCTest

final class SignalTests: XCTestCase {

    func testFilterMap() {
        let (signal, sink) = Signal<Int, NoError>.pipe()
        var values: [String] = []

        signal
            .filterMap {
                return $0 % 2 == 0 ? String($0) : nil
            }
            .observe(next: { values.append($0) })

        sendNext(sink, 1)
        XCTAssert(values == [])

        sendNext(sink, 2)
        XCTAssert(values == ["2"])

        sendNext(sink, 3)
        XCTAssert(values == ["2"])

        sendNext(sink, 6)
        XCTAssert(values == ["2", "6"])
    }

    func testIgnoreErrorCompletion() {
        let (signal, sink) = Signal<Int, TestError>.pipe()
        var completed = false

        signal
            .ignoreError()
            .observe(completed: {
                completed = true
            })

        sendNext(sink, 1)
        XCTAssertFalse(completed)

        sendError(sink, .Default)
        XCTAssertTrue(completed)
    }

    func testIgnoreErrorInterruption() {
        let (signal, sink) = Signal<Int, TestError>.pipe()
        var interrupted = false

        signal
            .ignoreError(replacement: .Interrupted)
            .observe(interrupted: {
                interrupted = true
            })

        sendNext(sink, 1)
        XCTAssertFalse(interrupted)

        sendError(sink, .Default)
        XCTAssertTrue(interrupted)
    }

    func testTimeoutAfterTerminating() {
        let scheduler = TestScheduler()
        let (signal, sink) = Signal<Int, NoError>.pipe()
        var interrupted = false
        var completed = false

        signal
            .timeoutAfter(2, withEvent: .Interrupted, onScheduler: scheduler)
            .observe(
                completed: { completed = true },
                interrupted: { interrupted = true }
            )

        scheduler.scheduleAfter(1) { sendCompleted(sink) }

        XCTAssertFalse(interrupted)
        XCTAssertFalse(completed)

        scheduler.run()
        XCTAssertTrue(completed)
        XCTAssertFalse(interrupted)
    }

    func testTimeoutAfterTimingOut() {
        let scheduler = TestScheduler()
        let (signal, sink) = Signal<Int, NoError>.pipe()
        var interrupted = false
        var completed = false

        signal
            .timeoutAfter(2, withEvent: .Interrupted, onScheduler: scheduler)
            .observe(
                completed: { completed = true },
                interrupted: { interrupted = true }
            )

        scheduler.scheduleAfter(3) { sendCompleted(sink) }

        XCTAssertFalse(interrupted)
        XCTAssertFalse(completed)

        scheduler.run()
        XCTAssertTrue(interrupted)
        XCTAssertFalse(completed)
    }

    func testUncollect() {
        let (signal, sink) = Signal<[Int], NoError>.pipe()
        var values: [Int] = []

        signal
            .uncollect()
            .observe(next: {
                values.append($0)
            })

        sendNext(sink, [])
        XCTAssert(values.isEmpty)

        sendNext(sink, [1])
        XCTAssert(values == [1])

        sendNext(sink, [2, 3])
        XCTAssert(values == [1, 2, 3])
    }
    
    func testNot() {
        let (signal, sink) = Signal<Bool, NoError>.pipe()
        var invertedValue = false
        
        signal
            .not()
            .observe(next: {
                invertedValue = $0
            })
        
        sendNext(sink, false)
        XCTAssertTrue(invertedValue)

        sendNext(sink, true)
        XCTAssertFalse(invertedValue)
    }
    
    func testAndSequenceType() {
        let (signal, sink) = Signal<[Bool], NoError>.pipe()
        var result = false
        
        signal
            .and()
            .observe(next: {
                result = $0
            })
        
        sendNext(sink, [true, true])
        XCTAssertTrue(result)
        
        sendNext(sink, [true, false])
        XCTAssertFalse(result)
        
        sendNext(sink, [false, true])
        XCTAssertFalse(result)
        
        sendNext(sink, [false, false])
        XCTAssertFalse(result)
    }
    
    func testOrSequenceType() {
        let (signal, sink) = Signal<[Bool], NoError>.pipe()
        var result = false
        
        signal
            .or()
            .observe(next: {
                result = $0
            })
        
        sendNext(sink, [true, true])
        XCTAssertTrue(result)
        
        sendNext(sink, [true, false])
        XCTAssertTrue(result)
        
        sendNext(sink, [false, true])
        XCTAssertTrue(result)
        
        sendNext(sink, [false, false])
        XCTAssertFalse(result)
    }
    
    func testAndTuple2() {
        let (signal, sink) = Signal<(Bool, Bool), NoError>.pipe()
        var result = false
        
        signal
            .and()
            .observe(next: {
                result = $0
            })
        
        sendNext(sink, (true, true))
        XCTAssertTrue(result)
        
        sendNext(sink, (true, false))
        XCTAssertFalse(result)
        
        sendNext(sink, (false, true))
        XCTAssertFalse(result)
        
        sendNext(sink, (false, false))
        XCTAssertFalse(result)
    }
    
    func testOrTuple2() {
        let (signal, sink) = Signal<(Bool, Bool), NoError>.pipe()
        var result = false
        
        signal
            .or()
            .observe(next: {
                result = $0
            })
        
        sendNext(sink, (true, true))
        XCTAssertTrue(result)
        
        sendNext(sink, (true, false))
        XCTAssertTrue(result)
        
        sendNext(sink, (false, true))
        XCTAssertTrue(result)
        
        sendNext(sink, (false, false))
        XCTAssertFalse(result)
    }
}

enum TestError: ErrorType {
    case Default
}
