//
//  UIPageControl.swift
//  Rex
//
//  Created by Torsten Curdt on 7/24/16.
//  Copyright (c) 2015 Torsten Curdt. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UIPageControl {

    /// Wraps a label's `numberOfPages` value in a bindable property.
    public var rex_numberOfPages: MutableProperty<Int> {
        return associatedProperty(self, key: &numberOfPagesKey, initial: { $0.numberOfPages }, setter: { $0.numberOfPages = $1 })
    }

    /// Wraps a label's `currentPage` value in a bindable property.
    public var rex_currentPage: MutableProperty<Int> {
        return associatedProperty(self, key: &currentPageKey, initial: { $0.currentPage }, setter: { $0.currentPage = $1 })
    }
}

private var numberOfPagesKey: UInt8 = 0
private var currentPageKey: UInt8 = 0
