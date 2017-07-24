//
//  NSData.swift
//  Rex
//
//  Created by Ilya Laryionau on 10/05/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift

extension Data {
    /// Read the data at the URL, sending the result or an error.
    public static func rex_dataWithContentsOfURL(_ url: NSURL, options: NSData.ReadingOptions = NSData.ReadingOptions()) -> SignalProducer<NSData, NSError> {
        return SignalProducer<NSData, NSError> { observer, disposable in
            do {
                let data = try NSData(contentsOf: url as URL, options: options)
                observer.send(value: data)
                observer.sendCompleted()
            } catch {
                observer.send(error: error as NSError)
            }
        }
    }
}
