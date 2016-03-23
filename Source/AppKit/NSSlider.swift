//
//  NSSlider+ReactiveExtensions.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/6/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension NSSlider {
    public var rex_doubleValueAction: Action<NSSlider, Double, NoError> {
        return associatedObject(self, key: &doubleValueActionKey) { _ in Action<NSSlider, Double, NoError> { SignalProducer(value: $0.doubleValue) } }
    }
    
    public var rex_doubleValues: Signal<Double, NoError> {
        let cocoaAction = associatedObject(self, key: &doubleValueCocoaActionKey) { CocoaAction($0.rex_doubleValueAction) { $0 as! NSSlider } }
        rex_action.value = cocoaAction
        
        return rex_doubleValueAction.values
    }
}

private var doubleValueActionKey: UInt8 = 0
private var doubleValueCocoaActionKey: UInt8 = 0