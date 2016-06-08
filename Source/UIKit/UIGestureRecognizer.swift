//
//  UIGestureRecognizer.swift
//  Rex
//
//  Created by Siemen Sikkema on 25/05/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UIGestureRecognizer {

	/// Wraps a gesture recognizer's `enabled` state in a bindable property.
	public var rex_enabled: MutableProperty<Bool> {
		return associatedProperty(self, key: &enabledKey, initial: { $0.enabled }, setter: { $0.enabled = $1 })
	}

	/// Exposes a property that binds an action to gesture events. The action is set as
	/// a target of the gesture recognizer. When property changes occur the
	/// previous action is removed as a target. This also binds the enabled state of the
	/// action to the `rex_enabled` property on the button.
	public var rex_action: MutableProperty<CocoaAction> {
		return associatedObject(self, key: &actionKey) { host in
			let initial = CocoaAction.rex_disabled
			let property = MutableProperty(initial)

			property.producer
				.combinePrevious(initial)
				.startWithNext { [weak host] previous, next in
					host?.removeTarget(previous, action: CocoaAction.selector)
					host?.addTarget(next, action: CocoaAction.selector)
			}

			host.rex_enabled <~ property.producer.flatMap(.Latest) { $0.rex_enabledProducer }

			return property
		}
	}
}

private var actionKey: UInt8 = 0
private var enabledKey: UInt8 = 0
