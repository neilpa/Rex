//
//  ConsumerBinding.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2016-01-09.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// The `ConsumerBinding` represents a single point where values can be "bound" to a UI object that consumes the specified `Value` type and executes control-specific behavior upon receipt of those values.
///
/// In practice, there can be more than one type of binding that may be exposed by a given object. For example, an `NSPopUpButton` can accept bindings to its selectedIndex, its selectedTag, its displayed and selected menuItem, etc. It must respond differently to each of those bindings.
public final class ConsumerBinding<Value> {
    private let _handler: BindingValue<Value> -> Void
    private let _disposable: CompositeDisposable
    
    /// Initialize the `ConsumerBinding` with the given behavior
    /// - param handler: Called whenever a new `BindingValue` is received, the handler is called on the UI thread and can configure the UI control to display the value.
    public init(handler: (BindingValue<Value>) -> Void) {
        _handler = handler
        _disposable = CompositeDisposable()
    }
}

extension ConsumerBinding : BindingValueConsumer {
    /// Binds the specified producer to this instance
    public func bindToProducer(producer: SignalProducer<BindingValue<Value>, NoError>) {
        _disposable += producer
            .observeOn(UIScheduler())   // Assert the handlers happen on the UI thread
            .startWithNext(_handler)
    }
    
    /// Binds the specified signal to this instance
    public func bindToSignal(signal: Signal<BindingValue<Value>, NoError>) {
        _disposable += signal
            .observeOn(UIScheduler())   // Assert the handlers happen on the UI thread
            .observeNext(_handler)
    }
}