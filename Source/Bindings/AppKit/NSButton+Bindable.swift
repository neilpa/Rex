//
//  NSButton+Bindable.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2016-01-11.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSButton {
    public var rex_stateBinding: ConsumerBinding<Int> {
        return associatedObject(self, key: &stateBindingKey) { button in
            ConsumerBinding() { value in
                switch value {
                case let .value(v):
                    button.state = v
                default:
                    button.state = NSMixedState
                }
            }
        }
    }
}

private var stateBindingKey: UInt8 = 0
