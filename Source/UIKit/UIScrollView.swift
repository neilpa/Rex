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
	public typealias Animated = Bool
	
	/// Wraps a scrollview's `contentOffset` value in a bindable property.
	public var rex_contentOffset: MutableProperty<(CGPoint, Animated)> {
		return associatedProperty(self, key: &contentOffsetKey, initial: { ($0.contentOffset, false) }, setter: { $0.setContentOffset($1.0, animated: $1.1) })
	}
	
	/// Wraps a scrollview's `contentSize` value in a bindable property.
	public var rex_contentSize: MutableProperty<CGSize> {
		return associatedProperty(self, key: &contentSizeKey, initial: { $0.contentSize }, setter: { $0.contentSize = $1 })
	}
}

private var contentOffsetKey: UInt8 = 0
private var contentSizeKey: UInt8 = 0