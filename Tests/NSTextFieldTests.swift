//
//  NSTextFieldTests.swift
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

final class NSTextFieldTests : XCTestCase {
    weak var _textField: NSTextField?
    
    override func tearDown() {
        XCTAssert(_textField == nil, "Retain cycle detected in NSTextField properties")
        super.tearDown()
    }

    func testTextColorPropertyDoesntCreateRetainCycle() {
        let label = NSTextField(frame: .zero)
        _textField = label
        
        label.rex_textColor <~ SignalProducer(value: NSColor.green)
        XCTAssert(_textField?.textColor == NSColor.green)
    }
}
