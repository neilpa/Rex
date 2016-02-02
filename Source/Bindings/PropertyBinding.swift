//
//  PropertyBinding.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/6/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// A `PropertyBinding` matches up a property with a function that validates incoming values to the property, and wraps the two into a new `MutablePropertyType` that can be treated as its own property, and bound to.
public final class PropertyBinding<Property: MutablePropertyType> {

    /// Validators are expected to return either `nil` if the input value is invalid, the passed-in value, or a corrected version of the passed-in value. The behavior is completely up to the implementor.
    public typealias Validator = Property.Value -> Property.Value?
    
    private let _property: Property
    private let _validator: Validator?
    
    public init(property: Property, validator: Validator?) {
        _property = property
        _validator = validator
    }
}

extension PropertyBinding : MutablePropertyType {
    public var producer: SignalProducer<Property.Value, NoError> {
        return _property.producer
    }
    
    public var signal: Signal<Property.Value, NoError> {
        return _property.signal
    }
    
    public var value: Property.Value {
        get { return _property.value }
        set { _property.value = (_validator == nil) ? newValue : (_validator?(newValue) ?? _property.value) }
    }
}

public extension TypedDynamicProperty {
    public typealias Validator = Value -> Value?
    public typealias Binding = PropertyBinding<TypedDynamicProperty<Value>>

    /// Returns a binding for the specified `object` and `keyPath`, with an optional `validator` that returns a valid, replacement value, or nil if the value is invalid.
    public class func bindingForObject(object: NSObject, withKeyPath keyPath: String, validator: Validator?) -> Binding {
        return PropertyBinding(property: TypedDynamicProperty<Value>(object: object, keyPath: keyPath), validator: validator)
    }
    
    /// Wraps this instance in a `PropertyBinding` object, using the specified validator function.
    ///
    /// Example:
    ///
    /// ```
    /// final class Volume {
    ///   dynamic var volume: Double // Between 0 and 1. Could be defined in an ObjC parent class.
    ///
    ///   var rex_volume: TypedDynamicProperty<Float>.Binding {
    ///     return associatedObject(self, key: &durationKey) {
    ///       TypedDynamicProperty(object: $0, keyPath: "volume").bindingWithValidator($0.validVolume)
    ///     }
    ///   }
    ///
    ///   private func validVolume(newVolume: Double) -> Double? {
    ///     return max(0.0, min(1.0, newVolume))
    ///   }
    /// }
    /// ```
    public func bindingWithValidator(validator: Validator?) -> Binding {
        return PropertyBinding(property: self, validator: validator)
    }
}
