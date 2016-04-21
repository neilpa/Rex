//
//  UIScrollViewTests.swift
//  Rex
//
//  Created by Yoshiki Kudo on 2016/04/21.
//  Copyright © 2016年 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit
import XCTest
import enum Result.NoError

class UIScrollViewTests: XCTestCase {
	
	weak var _scrollView: UIScrollView?
    
	override func tearDown() {
		XCTAssert(_scrollView == nil, "Retain cycle detected in UIView properties")
		super.tearDown()
	}
    
	func testContentOffsetProperty() {
		let scrollView = UIScrollView(frame: CGRectZero)
		_scrollView = scrollView
		
		let offset = CGPoint(x: 1.0, y: 1.0)
		
		scrollView.rex_contentOffset <~ SignalProducer(value: offset)
		XCTAssert(_scrollView?.contentOffset == offset)
	}
	
	func testContentSizeProperty() {
		let scrollView = UIScrollView(frame: CGRectZero)
		_scrollView = scrollView
		
		let size = CGSize(width: 1.0, height: 1.0)
		
		scrollView.rex_contentSize <~ SignalProducer(value: size)
		XCTAssert(_scrollView?.contentSize == size)
	}
	
	func testContentInsetProperty() {
		let scrollView = UIScrollView(frame: CGRectZero)
		_scrollView = scrollView
		
		let inset = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
		
		scrollView.rex_contentInset <~ SignalProducer(value: inset)
		XCTAssert(_scrollView?.contentInset == inset)
	}
}
