//
//  UIPageControl.swift
//  Rex
//
//  Created by Torsten Curdt on 7/24/16.
//  Copyright (c) 2015 Torsten Curdt. All rights reserved.
//

import XCTest
import ReactiveCocoa
import Result

class UIPageControlTests: XCTestCase {

    weak var _pageControl: UIPageControl?

    override func tearDown() {
        XCTAssert(_pageControl == nil, "Retain cycle detected in UIPageControl properties")
        super.tearDown()
    }

    func testNumberOfPages() {
        let pageControl = UIPageControl(frame: CGRectZero)
        _pageControl = pageControl

        let (pipeSignal, observer) = Signal<Int, NoError>.pipe()
        pageControl.rex_numberOfPages <~ SignalProducer(signal: pipeSignal)

        observer.sendNext(1)
        XCTAssertTrue(pageControl.numberOfPages == 1)
        observer.sendNext(2)
        XCTAssertTrue(pageControl.numberOfPages == 2)
    }

    func testNumberOfPages() {
        let pageControl = UIPageControl(frame: CGRectZero)
        _pageControl = pageControl

        let (pipeSignal, observer) = Signal<Int, NoError>.pipe()
        pageControl.rex_currentPage <~ SignalProducer(signal: pipeSignal)

        observer.sendNext(1)
        XCTAssertTrue(pageControl.currentPage == 1)
        observer.sendNext(2)
        XCTAssertTrue(pageControl.currentPage == 2)
    }
}
