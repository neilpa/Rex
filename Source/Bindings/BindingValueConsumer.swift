//
//  BindingValueConsumer.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/6/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift

/// A consumer of `BindingValue`s
public protocol BindingValueConsumer {
    associatedtype Value
    associatedtype Error: Swift.Error
    
    /// Bind the object to a producer of `BindingValue`s
    func bind(producer: SignalProducer<BindingValue<Value>, Error>)
    func bind(signal: Signal<BindingValue<Value>, Error>)
}

public func <~<Control: BindingValueConsumer, Value, Error>(control: Control, producer: SignalProducer<Value, Error>) where Control.Value == Value, Control.Error == Error {
    control.bind(producer: producer.map { BindingValue<Value>.value($0) })
}

public func <~<Control: BindingValueConsumer, Value, Error>(control: Control, signal: Signal<Value, Error>) where Control.Value == Value, Control.Error == Error {
    control.bind(signal: signal.map { BindingValue<Value>.value($0) })
}

/// Connect a producer of arrays of values (i.e. a selection, or many-to-one binding) to a `BindingValueConsumer`
public func <~<Control: BindingValueConsumer, Value: Equatable, Error>(control: Control, producer: SignalProducer<[Value], Error>) where Control.Value == Value, Control.Error == Error {
    control.bind(producer: producer.map { BindingValue<Value>(values: $0) })
}

/// Connect a producer of `BindingValue` objects to a `BindingValueConsumer`. This is useful when you supply your own custom mapping from an array of objects to a `BindingValue`.
public func <~<Control: BindingValueConsumer, Value, Error>(control: Control, producer: SignalProducer<BindingValue<Value>, Error>) where Control.Value == Value, Control.Error == Error {
    control.bind(producer: producer)
}
