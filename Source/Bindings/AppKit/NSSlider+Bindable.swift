//
//  NSSlider+Bindable.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSSlider {
    var rex_doubleValueBinding : ConsumerBinding<Double> {
        return associatedObject(self, key: &doubleValueBindingKey) { slider in
            ConsumerBinding() { value in
                if case let .Value(v) = value {
                    slider.doubleValue = v
                }
            }
        }
    }
}

private var doubleValueBindingKey: UInt8 = 0