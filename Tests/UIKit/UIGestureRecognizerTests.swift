//
//  UIGestureRecognizerTests.swift
//  Rex
//
//  Created by Siemen Sikkema on 25/05/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit
import XCTest
import enum Result.NoError

private extension UIGestureRecognizer {
	func sendActionToTarget() {
		guard let
			targets = valueForKey("targets") as? [NSObject],
			cocoaAction = targets.first?.valueForKey("target") as? CocoaAction
			else {
				return
		}

		cocoaAction.execute(nil)
	}
}

class UIGestureRecognizerTests: XCTestCase {

	weak var _gestureRecognizer: UITapGestureRecognizer?

	override func tearDown() {
		XCTAssert(_gestureRecognizer == nil, "Retain cycle detected in UIButton properties")
		super.tearDown()
	}

	func testEnabledPropertyDoesntCreateRetainCycle() {
		let gestureRecognizer = UITapGestureRecognizer()
		_gestureRecognizer = gestureRecognizer

		gestureRecognizer.rex_enabled <~ SignalProducer(value: false)
		XCTAssert(_gestureRecognizer?.enabled == false)
	}

	func testEnabledProperty() {
		let gestureRecognizer = UITapGestureRecognizer()
		gestureRecognizer.enabled = true

		let (pipeSignal, observer) = Signal<Bool, NoError>.pipe()
		gestureRecognizer.rex_enabled <~ SignalProducer(signal: pipeSignal)


		observer.sendNext(false)
		XCTAssertFalse(gestureRecognizer.enabled)
		observer.sendNext(true)
		XCTAssertTrue(gestureRecognizer.enabled)
	}

	func testActionPropertyDoesntCreateRetainCycle() {
		let gestureRecognizer = UITapGestureRecognizer()
		_gestureRecognizer = gestureRecognizer

		let action = Action<(),(),NoError> {
			SignalProducer(value: ())
		}
		gestureRecognizer.rex_action <~ SignalProducer(value: CocoaAction(action, input: ()))
	}

	func testActionProperty() {
		let gestureRecognizer = UITapGestureRecognizer()
		gestureRecognizer.enabled = true

		let passed = MutableProperty(false)
		let action = Action<(), Bool, NoError> { _ in
			SignalProducer(value: true)
		}

		passed <~ SignalProducer(signal: action.values)
		gestureRecognizer.rex_action <~ SignalProducer(value: CocoaAction(action, input: ()))

		gestureRecognizer.sendActionToTarget()

		XCTAssertTrue(passed.value)
	}
}
