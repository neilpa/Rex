//
//  NSButton+ReactiveExtensions.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2016-01-11.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension NSButton {
    public var rex_stateAction: Action<NSButton, Int, NoError> {
        return associatedObject(self, key: &stateActionKey) { _ in Action<NSButton, Int, NoError> { SignalProducer(value: $0.state) } }
    }
    
    public var rex_states: Signal<Int, NoError> {
        let cocoaAction = associatedObject(self, key: &stateCocoaActionKey) { CocoaAction($0.rex_stateAction) { $0 as! NSButton } }
        rex_action.value = cocoaAction
        
        return rex_stateAction.values
    }
}

private var stateActionKey: UInt8 = 0
private var stateCocoaActionKey: UInt8 = 0