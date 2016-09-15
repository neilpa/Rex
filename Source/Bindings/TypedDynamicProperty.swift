//
//  TypedDynamicProperty.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

/// Wraps a `DynamicProperty` instance in an effort to handle the casting that is often required when bridging from the KVO-powered class.
public final class TypedDynamicProperty<Value: AnyObject> : MutablePropertyProtocol {
    /// The lifetime of `self`. The binding operators use this to determine when
    /// the binding should be teared down.
    public var lifetime: Lifetime {
        return _property.lifetime
    }

    fileprivate let _property: DynamicProperty<Value>
    fileprivate init(_ property: DynamicProperty<Value>) {
        _property = property
    }
    
    public convenience init(object: NSObject, keyPath: String) {
        self.init(DynamicProperty<Value>(object: object, keyPath: keyPath))
    }
    
    public var value: Value {
        get { return _property.value! }
        set { _property.value = newValue }
    }
    
    public var producer: SignalProducer<Value, NoError> { return _property.producer.map { $0! } }
    public var signal: Signal<Value, NoError> { return _property.signal.map { $0! } }
}
