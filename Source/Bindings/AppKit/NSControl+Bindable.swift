//
//  NSControl+Bindable.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/30/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSControl {
    public var rex_enabledBinding: ConsumerBinding<Bool> {
        return associatedObject(self, key: &enabledBindingKey) { control in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    control.enabled = v
                default:
                    // If the enabled states are mixed, then we assume it's false
                    control.enabled = false
                }
            }
        }
    }
}

private var enabledBindingKey: UInt8 = 0