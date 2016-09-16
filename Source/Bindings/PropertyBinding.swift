//
//  PropertyBinding.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/6/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

/// A `PropertyBinding` matches up a property with a function that validates incoming values to the property, and wraps the two into a new `MutablePropertyType` that can be treated as its own property, and bound to.
public final class ValidatingBinding<Target: BindingTarget, ValidationError: Error>: BindingTarget {
    /// Validators are expected to return either `nil` if the input value is invalid, the passed-in value, or a corrected version of the passed-in value. The behavior is completely up to the implementor.
    public typealias Validator = (Target.Value) -> Result<Target.Value, ValidationError>
    
    fileprivate let _target: Target
    fileprivate let _validator: Validator?
    
    public init(target: Target, validator: Validator?) {
        _target = target
        _validator = validator
    }

    /// The lifetime of `self`. The binding operators use this to determine when
    /// the binding should be teared down.
    public var lifetime: Lifetime {
        return _target.lifetime
    }

    /// Stores the last validation error that was triggered upon consumption
    public let validationError = MutableProperty<ValidationError?>(nil)

    /// Consume a value from the binding.
    public func consume(_ value: Target.Value) {
        guard let newValue = (_validator == nil) ? .success(value) : _validator?(value) else {
            return
        }

        switch newValue {
        case .success(let validated):
            _target.consume(validated)
        case .failure(let error):
            validationError.value = error
        }
    }
}

public extension NSObject {
    /// Creates a binding for the given keyPath and supplied validator function
    public func rex_binding<Value, ValidationError>(forKeyPath keyPath: String, validator: ValidatingBinding<DynamicProperty<Value>, ValidationError>.Validator?) -> ValidatingBinding<DynamicProperty<Value>, ValidationError> where Value: _ObjectiveCBridgeable, ValidationError: Error {
        return ValidatingBinding(target: DynamicProperty<Value>(object: self, keyPath: keyPath), validator: validator)
    }

    /// Creates a binding for the given keyPath and supplied validator function
    public func rex_binding<Value, ValidationError>(forKeyPath keyPath: String, validator: ValidatingBinding<DynamicProperty<Value>, ValidationError>.Validator?) -> ValidatingBinding<DynamicProperty<Value>, ValidationError> where Value: AnyObject, ValidationError: Error {
        return ValidatingBinding(target: DynamicProperty<Value>(object: self, keyPath: keyPath), validator: validator)
    }
}

public extension BindingTarget where Value: AnyObject {
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
    public func bindingWithValidator<ValidationError>(_ validator: ValidatingBinding<Self, ValidationError>.Validator?) -> ValidatingBinding<Self, ValidationError> {
        return ValidatingBinding(target: self, validator: validator)
    }
}
