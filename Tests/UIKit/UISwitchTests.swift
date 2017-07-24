//
//  UISwitchTests.swift
//  Rex
//
//  Created by David Rodrigues on 07/04/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import XCTest
import ReactiveSwift
import Result

class UISwitchTests: XCTestCase {
    
    func testOnProperty() {
        let `switch` = UISwitch(frame: .zero)
        `switch`.isOn = false

        let (pipeSignal, observer) = Signal<Bool, NoError>.pipe()
        `switch`.reactive.isOn <~ SignalProducer(signal: pipeSignal)

        observer.send(value: true)
        XCTAssertTrue(`switch`.isOn)
        observer.send(value: false)
        XCTAssertFalse(`switch`.isOn)

        let onProperty =  MutableProperty<Bool>(false)
        onProperty <~ `switch`.reactive.isOnValues
        `switch`.isOn = true
        `switch`.sendActions(for: .valueChanged)
        XCTAssertTrue(onProperty.value)        
    }
}
