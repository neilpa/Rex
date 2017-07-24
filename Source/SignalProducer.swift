//
//  SignalProducer.swift
//  Rex
//
//  Created by Neil Pankey on 5/9/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import enum Result.NoError

extension SignalProducerProtocol {

    /// Buckets each received value into a group based on the key returned
    /// from `grouping`. Termination events on the original signal are
    /// also forwarded to each producer group.
    
    public func groupBy<Key: Hashable>(_ grouping: @escaping (Value) -> Key) -> SignalProducer<(Key, SignalProducer<Value, Error>), Error> {
        return SignalProducer<(Key, SignalProducer<Value, Error>), Error> { observer, disposable in
            var groups: [Key: Signal<Value, Error>.Observer] = [:]

            let lock = NSRecursiveLock()
            lock.name = "me.neilpa.rex.groupBy"

            self.start { event in
                switch event {
                case let .value(value):
                    let key = grouping(value)

                    lock.lock()
                    var group = groups[key]
                    if group == nil {
                        let (signal, innerObserver) = Signal<Value, Error>.pipe()
                        let producer = SignalProducer(signal: signal).replayLazily(upTo: Int.max)
                        
                        // Start the buffering immediately.
                        producer.start()
                        observer.send(value: (key, producer))

                        groups[key] = innerObserver
                        group = innerObserver
                    }
                    lock.unlock()
                    
                    group!.send(value: value)

                case let .failed(error):
                    observer.send(error: error)
                    groups.values.forEach { $0.send(error: error) }

                case .completed:
                    observer.sendCompleted()
                    groups.values.forEach { $0.sendCompleted() }

                case .interrupted:
                    observer.sendInterrupted()
                    groups.values.forEach { $0.sendInterrupted() }
                }
            }
        }
    }

    /// Applies `transform` to values from self with non-`nil` results unwrapped and
    /// forwared on the returned producer.
    
    public func filterMap<U>(_ transform: @escaping (Value) -> U?) -> SignalProducer<U, Error> {
        return lift { $0.filterMap(transform) }
    }

    /// Returns a producer that drops `Error` sending `replacement` terminal event
    /// instead, defaulting to `Completed`.
    
    public func ignoreError(_ replacement: Event<Value, NoError> = .completed) -> SignalProducer<Value, NoError> {
        precondition(replacement.isTerminating)
        return lift { $0.ignoreError(replacement) }
    }

    /// Forwards events from self until `interval`. Then if producer isn't completed yet,
    /// terminates with `event` on `scheduler`.
    ///
    /// If the interval is 0, the timeout will be scheduled immediately. The producer
    /// must complete synchronously (or on a faster scheduler) to avoid the timeout.
    
    public func timeoutAfter(_ interval: TimeInterval, withEvent event: Event<Value, Error>, onScheduler scheduler: DateSchedulerProtocol) -> SignalProducer<Value, Error> {
        return lift { $0.timeoutAfter(interval, withEvent: event, onScheduler: scheduler) }
    }

    /// Forwards a value and then mutes the producer by dropping all subsequent values
    /// for `interval` seconds. Once time elapses the next new value will be forwarded
    /// and repeat the muting process. Error events are immediately forwarded even while
    /// the producer is muted.
    ///
    /// This operator could be used to coalesce multiple notifications in a short time
    /// frame by only showing the first one.
    
    public func muteFor(_ interval: TimeInterval, clock: DateSchedulerProtocol) -> SignalProducer<Value, Error> {
        return lift { $0.muteFor(interval, clock: clock) }
    }

    /// Delays the start of the producer by `interval` on the provided scheduler.
    
    public func deferred(_ interval: TimeInterval, onScheduler scheduler: DateSchedulerProtocol) -> SignalProducer<Value, Error> {
        return SignalProducer.empty
            .delay(interval, on: scheduler)
            .concat(self.producer)
    }

    /// Delays retrying on failure by `interval` up to `count` attempts.
    
    public func deferredRetry(_ interval: TimeInterval, onScheduler scheduler: DateSchedulerProtocol, count: Int = .max) -> SignalProducer<Value, Error> {
        precondition(count >= 0)

        if count == 0 {
            return producer
        }

        var retries = count
        return flatMapError { error in
                // The final attempt shouldn't defer the error if it fails
                var producer = SignalProducer<Value, Error>(error: error)
                if retries > 0 {
                    producer = producer.deferred(interval, onScheduler: scheduler)
                }

                retries -= 1
                return producer
            }
            .retry(upTo: count)
    }
}

extension SignalProducerProtocol where Value: Sequence {
    /// Returns a producer that flattens sequences of elements. The inverse of `collect`.
    
    public func uncollect() -> SignalProducer<Value.Iterator.Element, Error> {
        return lift { $0.uncollect() }
    }
}
