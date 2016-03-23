//
//  NSControl.swift
//  Rex
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import Foundation
import AppKit
import ReactiveCocoa
import Result

extension NSControl {
    /// Exposes a property that binds an action to the control's target/action. The action 
    /// is set as a target of the control's events. For instance, an NSButton would trigger 
    /// its action when pressed, a NSSlider would trigger its action when the value 
    /// changes, a NSTextField triggers when its value changes, and so on. When property 
    /// changes occur the previous action is overwritten as a target. This also binds the 
    /// enabled state of the action to the `rex_enabled` property on the button.
    public var rex_action: MutableProperty<CocoaAction> {
        return associatedObject(self, key: &actionKey, initial: { [weak self] _ in
            let initial = CocoaAction.rex_disabled
            let property = MutableProperty(initial)
            
            property.producer
                .startWithNext { next in
                    self?.target = next
                    self?.action = CocoaAction.selector
            }
            
            if let strongSelf = self {
                strongSelf.rex_enabled <~ property.producer.flatMap(.Latest) { $0.rex_enabledProducer }
            }
            
            return property
        })
    }

    /// Wraps a control's `enabled` state in a bindable property.
    public var rex_enabled: MutableProperty<Bool> {
        return associatedProperty(self, key: &enabledKey, initial: { $0.enabled }, setter: { $0.enabled = $1 })
    }
    
    /// Wraps a control's alpha value in a bindable property.
    public var rex_alphaValue: MutableProperty<CGFloat> {
        return associatedProperty(self, key: &alphaValueKey, initial: { $0.alphaValue }, setter: { $0.alphaValue = $1 })
    }
}

private var enabledKey: UInt8 = 0
private var alphaValueKey: UInt8 = 0
private var actionKey: UInt8 = 0