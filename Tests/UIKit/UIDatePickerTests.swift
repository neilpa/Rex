//
//  UIDatePickerTests.swift
//  Rex
//
//  Created by Guido Marucci Blas on 3/25/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import XCTest
import Rex
import enum Result.NoError

class UIDatePickerTests: XCTestCase {
    
    var date: Date!
    var picker: UIDatePicker!
    
    override func setUp() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        date = formatter.date(from: "11/29/1988")!
        
        picker = UIDatePicker(frame: .zero)
    }
    
    func testUpdatePickerFromProperty() {
        let (signal, observer) = Signal<Date, NoError>.pipe()
        picker.reactive.date <~ signal
        observer.send(value: date)
        
        XCTAssertEqual(picker.date, date)
    }

    func testUpdatePropertyFromPicker() {
        let expectation = self.expectation(description: "Expected rex_date to send an event when picker's date value is changed by a UI event")
        defer { self.waitForExpectations(timeout: 2, handler: nil) }
        
        picker.reactive.dates.observeValues { changedDate in
            XCTAssertEqual(changedDate as Date, self.date)
            expectation.fulfill()
        }
        
        picker.date = date
        picker.isEnabled = true
        picker.isUserInteractionEnabled = true
        picker.sendActions(for: .valueChanged)
    }
}
