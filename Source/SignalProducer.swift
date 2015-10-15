//
//  SignalProducer.swift
//  Rex
//
//  Created by Neil Pankey on 5/9/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType {

    /// Bring back the `start` overload. The `startNext` or pattern matching
    /// on `start(Event)` is annoying in practice and more verbose. This is also
    /// likely to change in a later RAC 4 alpha.
    internal func start(next next: (T -> ())? = nil, error: (E -> ())? = nil, completed: (() -> ())? = nil, interrupted: (() -> ())? = nil) -> Disposable? {
        return self.start { (event: Event<T, E>) in
            switch event {
            case let .Next(value):
                next?(value)
            case let .Error(err):
                error?(err)
            case .Completed:
                completed?()
            case .Interrupted:
                interrupted?()
            }
        }
    }

    /// Buckets each received value into a group based on the key returned
    /// from `grouping`. Termination events on the original signal are
    /// also forwarded to each producer group.
    public func groupBy<K: Hashable>(grouping: T -> K) -> SignalProducer<(K, SignalProducer<T, E>), E> {
        return SignalProducer<(K, SignalProducer<T, E>), E> { observer, disposable in
            var groups: [K: Signal<T, E>.Observer] = [:]

            let lock = NSRecursiveLock()
            lock.name = "me.neilpa.rex.groupBy"

            self.start(next: { value in
                let key = grouping(value)

                lock.lock()
                var group = groups[key]
                if group == nil {
                    let (producer, sink) = SignalProducer<T, E>.buffer()
                    sendNext(observer, (key, producer))

                    groups[key] = sink
                    group = sink
                }
                lock.unlock()

                sendNext(group!, value)

            }, error: { error in
                sendError(observer, error)
                groups.values.forEach { sendError($0, error) }

            }, completed: { _ in
                sendCompleted(observer)
                groups.values.forEach { sendCompleted($0) }

            }, interrupted: { _ in
                sendInterrupted(observer)
                groups.values.forEach { sendInterrupted($0) }
            })
        }
    }

    /// Applies `transform` to values from self with non-`nil` results unwrapped and
    /// forwared on the returned producer.
    public func filterMap<U>(transform: T -> U?) -> SignalProducer<U, E> {
        return lift { $0.filterMap(transform) }
    }

    /// Returns a producer that drops `Error` sending `replacement` terminal event
    /// instead, defaulting to `Completed`.
    public func ignoreError(replacement replacement: Event<T, NoError> = .Completed) -> SignalProducer<T, NoError> {
        precondition(replacement.isTerminating)
        return lift { $0.ignoreError(replacement: replacement) }
    }

    /// Forwards events from self until `interval`. Then if producer isn't completed yet,
    /// terminates with `event` on `scheduler`.
    ///
    /// If the interval is 0, the timeout will be scheduled immediately. The producer
    /// must complete synchronously (or on a faster scheduler) to avoid the timeout.
    public func timeoutAfter(interval: NSTimeInterval, withEvent event: Event<T, E>, onScheduler scheduler: DateSchedulerType) -> SignalProducer<T, E> {
        return lift { $0.timeoutAfter(interval, withEvent: event, onScheduler: scheduler) }
    }
}

extension SignalProducerType where T: SequenceType {
    /// Returns a producer that flattens sequences of elements. The inverse of `collect`.
    public func uncollect() -> SignalProducer<T.Generator.Element, E> {
        return lift { $0.uncollect() }
    }
}


// MARK: Boolean Operations

extension SignalProducerType where T: BooleanType {
    /// Returns a producer that inverts every value sent on self
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func not() -> SignalProducer<Bool, E> {
        return lift { $0.not() }
    }
}

extension SignalProducerType where T: SequenceType, T.Generator.Element: BooleanType {
    /// Returns a producer that sends `a && b && c && ...` for each value (a, b, c, ...) sent on self
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    public func and() -> SignalProducer<Bool, E> {
        return lift { $0.and() }
    }
    
    /// Returns a producer that sends `a ||& b || c || ...` for each value (a, b, c, ...) sent on self
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    public func or() -> SignalProducer<Bool, E> {
        return lift { $0.or() }
    }
}

extension SignalProducerType where T == (Bool, Bool) {
    /// Returns a producer that sends `a && b` for each value (a, b) sent on self
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    public func and() -> SignalProducer<Bool, E> {
        return lift { $0.and() }
    }
    
    /// Returns a producer that sends `a || b` for each value (a, b) sent on self
    @warn_unused_result(message="Did you forget to call `observe` on the signal?")
    public func or() -> SignalProducer<Bool, E> {
        return lift { $0.or() }
    }
}

