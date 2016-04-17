//
//  NSObject.swift
//  Rex
//
//  Created by Neil Pankey on 5/28/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

extension NSObject {
    /// Creates a strongly-typed producer to monitor `keyPath` via KVO. The caller
    /// is responsible for ensuring that the associated value is castable to `T`.
    ///
    /// Swift classes deriving `NSObject` must declare properties as `dynamic` for
    /// them to work with KVO. However, this is not recommended practice.
    public func rex_producerForKeyPath<T>(keyPath: String) -> SignalProducer<T, NoError> {
        return self.rac_valuesForKeyPath(keyPath, observer: nil)
            .toSignalProducer()
            .map { $0 as! T }
            .flatMapError { error in
                // Errors aren't possible, but the compiler doesn't know that.
                assertionFailure("Unexpected error from KVO signal: \(error)")
                return .empty
        }
    }
    
    /// Creates a signal that will be triggered when the object
    /// is deallocated.
    public var rex_willDeallocSignal: Signal<(), NoError> {
        return self
            .rac_willDeallocSignal()
            .rex_toTriggerSignal()
    }
	
	
	/// Returns a signal which will send a tuple of arguments upon each invocation of
	/// the selector, then completes when the receiver is deallocated. `next` events
	/// will be sent synchronously from the thread that invoked the method. If
	/// a runtime call fails, the signal will send an error in the
	/// RACSelectorSignalErrorDomain.
	/// It can be used for example to catch `@IBAction func`.
	public func rex_signalForSelector(selector: Selector) -> Signal<(AnyObject?, AnyObject?, AnyObject?, AnyObject?, AnyObject?, AnyObject?), NSError> {
		return self
			.rac_signalForSelector(selector)
			.rex_toSignal()
			.map{
				let tuple = $0 as? RACTuple
				guard let first = tuple?.first else		{ return (nil, nil, nil, nil, nil, nil) }
				guard let second = tuple?.second else	{ return (first, nil, nil, nil, nil, nil) }
				guard let third = tuple?.third else		{ return (first, second, nil, nil, nil, nil) }
				guard let fourth = tuple?.fourth else	{ return (first, second, third, nil, nil, nil) }
				guard let fifth = tuple?.fifth else		{ return (first, second, third, fourth, nil, nil) }
				guard let last = tuple?.last else		{ return (first, second, third, fourth, fifth, nil) }
				
				return (first, second, third, fourth, fifth, last)
		}
	}
}