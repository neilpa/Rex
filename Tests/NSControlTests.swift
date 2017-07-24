//
//  NSControlTests.swift
//  Rex
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

@testable import Rex
import ReactiveSwift
import ReactiveCocoa
import Foundation
import XCTest

final class NSControlTests : XCTestCase {
    weak var _control: NSControl?
    
    override func tearDown() {
        XCTAssert(_control == nil, "Retain cycle detected in UIControl properties")
        super.tearDown()
    }
    
    func testEnabledPropertyDoesntCreateRetainCycle() {
        let control = NSControl(frame: .zero)
        _control = control
        
        control.rex_enabled <~ SignalProducer(value: false)
        XCTAssert(_control?.isEnabled == false)
    }
    
    func testAlphaValuePropertyDoesntCreateRetainCycle() {
        let control = NSControl(frame: .zero)
        _control = control
        
        control.rex_alphaValue <~ SignalProducer(value: 0.0)
        XCTAssert(_control?.alphaValue == 0.0)
    }
}
