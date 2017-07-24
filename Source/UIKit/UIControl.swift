//
//  UIView.swift
//  Rex
//
//  Created by Neil Pankey on 6/19/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import enum Result.NoError

extension UIControl {

#if os(iOS)
    /// Creates a producer for the sender whenever a specified control event is triggered.
    private func _rex_controlEvents(events: UIControlEvents) -> Signal<UIControl?, NoError> {
        return reactive.trigger(for: events)
            .map { [weak self] _ in return self }
    }
    /// Creates a bindable property to wrap a control's value.
    /// 
    /// This property uses `UIControlEvents.ValueChanged` and `UIControlEvents.EditingChanged` 
    /// events to detect changes and keep the value up-to-date.
    //
    class func rex_value<Host: UIControl, T>(host: Host, getter: @escaping (Host) -> T, setter: @escaping (Host, T) -> ()) -> MutableProperty<T> {
        return associatedProperty(host, key: &valueChangedKey, initial: getter, setter: setter) { property in
            property <~
                host._rex_controlEvents(events: [.valueChanged, .editingChanged])
                    .filterMap { $0 as? Host }
                    .filterMap(getter)
        }
    }
#endif
}

private var valueChangedKey: UInt8 = 0
