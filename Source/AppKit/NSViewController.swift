//
//  NSViewController+ReactiveExtensions.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 1/30/16.
//  Copyright © 2016 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

extension NSViewController {

    /// Provides a "trigger signal" to allow us easier access to viewWillDisappear calls
    @available(OSX 10.10, *)
    public var rex_viewWillDisappear: Signal<Void, NoError> {
        return associatedObject(self, key: &viewWillDisappearKey) {
            var returnedSignal: Signal<Void, NoError>!
            
            $0.rac_signal(for: #selector(NSViewController.viewWillDisappear))
                .toSignalProducer()
                .map { _ in () }
                .flatMapError { error in
                    let str = "Unexpected error: \(error)"  // Needs to be a separate `let` to appease the compiler
                    fatalError(str)                         // Don't silently ignore errors.
                }
                .startWithSignal { theSignal, _ in
                    returnedSignal = theSignal
                }
            
            return returnedSignal
        }
    }
}

private var viewWillDisappearKey: UInt8 = 0
