//
//  UIScrollView.swift
//  Rex
//
//  Created by Yoshiki Kudo on 2016/04/20.
//  Copyright © 2016年 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UIScrollView {
	/// Wraps a scrollview's `contentOffset` value in a bindable property.
	public var rex_contentOffset: MutableProperty<CGPoint> {
		return associatedProperty(self, key: &contentOffsetKey, initial: { $0.contentOffset }, setter: { $0.contentOffset = $1 })
	}
	
	/// Wraps a scrollview's `contentSize` value in a bindable property.
	public var rex_contentSize: MutableProperty<CGSize> {
		return associatedProperty(self, key: &contentSizeKey, initial: { $0.contentSize }, setter: { $0.contentSize = $1 })
	}
	
	/// Wraps a scrollview's `contentInset` value in a bindable property.
	public var rex_contentInset: MutableProperty<UIEdgeInsets> {
		return associatedProperty(self, key: &contentInsetKey, initial: { $0.contentInset }, setter: { $0.contentInset = $1 })
	}
}

private var contentOffsetKey: UInt8 = 0
private var contentSizeKey: UInt8 = 0
private var contentInsetKey: UInt8 = 0