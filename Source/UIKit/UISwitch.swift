//
//  UISwitch.swift
//  Rex
//
//  Created by David Rodrigues on 07/04/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UISwitch {

    /// Wraps a switch's `on` state in a bindable property.
    public var rex_on: MutableProperty<Bool> {

        let property = associatedProperty(self, key: &onKey, initial: { $0.on }, setter: { $0.on = $1 })

        property <~ rex_controlEvents(.ValueChanged)
            .filterMap { ($0 as? UISwitch)?.on }

        return property
    }

    /// Exposes a property that binds an action into a control's value changed event.
    ///
    /// - Important: This also binds the enabled state of the action to the `rex_enabled`
    /// property on the control.
    ///
    /// - Warning: Since iOS 7, `UISwitch` can trigger multiple `.ValueChanged` notifications
    /// even when there's no change of value. This property observes internally changes on the
    /// `on` property and manually triggers the action when there's in fact a change of value.
    /// Because of this, the action will not be set as target of the control.
    /// [rdar://14485185](https://openradar.appspot.com/14485185)
    ///
    public var rex_valueChanged: MutableProperty<CocoaAction> {
        return associatedObject(self, key: &valueChangedKey) { host in
            let initial = CocoaAction.rex_disabled
            let property = MutableProperty(initial)

            host.rex_on
                .signal
                .skipRepeats()
                .combineLatestWith(property.signal)
                .observeNext { [weak host] _, action in action.execute(host) }

            host.rex_enabled <~ property.producer.flatMap(.Latest) { $0.rex_enabledProducer }

            return property
        }
    }
}

private var onKey: UInt8 = 0
private var valueChangedKey: UInt8 = 0
