//
//  BindingValueConsumer.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/6/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// A consumer of `BindingValue`s
protocol BindingValueConsumer {
    typealias Value
    typealias Error: ErrorType
    
    /// Bind the object to a producer of `BindingValue`s
    func bindToProducer(producer: SignalProducer<BindingValue<Value>, Error>)
    func bindToSignal(signal: Signal<BindingValue<Value>, Error>)
}

func <~<Control: BindingValueConsumer, Value, Error where Control.Value == Value, Control.Error == Error>(control: Control, producer: SignalProducer<Value, Error>) {
    control.bindToProducer(producer.map { BindingValue<Value>.Value($0) })
}

func <~<Control: BindingValueConsumer, Value, Error where Control.Value == Value, Control.Error == Error>(control: Control, signal: Signal<Value, Error>) {
    control.bindToSignal(signal.map { BindingValue<Value>.Value($0) })
}

/// Connect a producer of arrays of values (i.e. a selection, or many-to-one binding) to a `BindingValueConsumer`
func <~<Control: BindingValueConsumer, Value: Equatable, Error where Control.Value == Value, Control.Error == Error>(control: Control, producer: SignalProducer<[Value], Error>) {
    control.bindToProducer(producer.map { BindingValue<Value>(values: $0) })
}

/// Connect a producer of `BindingValue` objects to a `BindingValueConsumer`. This is useful when you supply your own custom mapping from an array of objects to a `BindingValue`.
func <~<Control: BindingValueConsumer, Value, Error where Control.Value == Value, Control.Error == Error>(control: Control, producer: SignalProducer<BindingValue<Value>, Error>) {
    control.bindToProducer(producer)
}