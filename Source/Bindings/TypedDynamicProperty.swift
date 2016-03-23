//
//  TypedDynamicProperty.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

/// Wraps a `DynamicProperty` instance in an effort to handle the casting that is often required when bridging from the KVO-powered class.
public final class TypedDynamicProperty<Value> : MutablePropertyType {
    private let _property: DynamicProperty
    private init(_ property: DynamicProperty) {
        _property = property
    }
    
    public convenience init(object: NSObject, keyPath: String) {
        self.init(DynamicProperty(object: object, keyPath: keyPath))
    }
    
    public var value: Value {
        get { return _property.value as! Value }
        set { _property.value = newValue as? AnyObject }
    }
    
    public var producer: SignalProducer<Value, NoError> { return _property.producer.map { $0 as! Value } }
    public var signal: Signal<Value, NoError> { return _property.signal.map { $0 as! Value } }
}