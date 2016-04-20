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
}

private var contentOffsetKey: UInt8 = 0