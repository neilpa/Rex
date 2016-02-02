//
//  NSTextField+ReactiveExtensions.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2015-12-13.
//  Copyright © 2015 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSTextField {
    var rex_stringValueBinding: ConsumerBinding<String> {
        return associatedObject(self, key: &stringValueBindingKey) { textField in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    textField.stringValue = v
                default:
                    // The placeholderString is only shown if the string value is cleared on the control
                    if #available(OSX 10.10, *) {
                        textField.stringValue = ""
                        textField.placeholderString = value.formatString({ _ in return "" })
                    } else {
                        // TODO: Below 10.10, we must also manipulate the string color/etc.
                        textField.stringValue = value.formatString({ _ in return "" })
                    }
                }
            }
        }
    }
}

private var stringValueBindingKey: UInt8 = 0