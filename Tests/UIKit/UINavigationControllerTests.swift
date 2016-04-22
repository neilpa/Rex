//
//  UINavigationControllerTests.swift
//  Rex
//
//  Created by Rui Peres on 22/04/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit
import XCTest
import enum Result.NoError

class UINavigationControllerTests: XCTestCase {
    
    weak var _navigationController: UINavigationController?
    
    override func tearDown() {
        XCTAssert(_navigationController == nil, "Retain cycle detected in UINavigationController properties")
        super.tearDown()
    }
    
    func testPopViewController_via_property() {
        
        let expectation = self.expectationWithDescription("Expected rex_popViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        navigationController.rex_popViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.rex_popViewController <~ SignalProducer(value: true)
    }
    
    func testPopViewController_via_cocoa() {
        
        let expectation = self.expectationWithDescription("Expected rex_popViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        navigationController.rex_popViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.popViewControllerAnimated(true)
    }
    
    func testPopToRootViewController_via_property() {
        
        let expectation = self.expectationWithDescription("Expected rex_popToRootViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        navigationController.rex_popToRootViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.rex_popToRootViewController <~ SignalProducer(value: true)
    }
    
    func testPopToRootViewController_via_cocoa() {
        
        let expectation = self.expectationWithDescription("Expected rex_popToRootViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        navigationController.rex_popToRootViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.popToRootViewControllerAnimated(true)
    }
    
    func testPopToViewController_via_property() {
        
        let expectation = self.expectationWithDescription("Expected rex_popToViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: false)
        
        navigationController.rex_popToViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.rex_popToViewController <~ SignalProducer(value: (viewController, true))
    }
    
    func testPopToViewController_via_cocoa() {
        
        let expectation = self.expectationWithDescription("Expected rex_popToViewController to be triggered")
        defer { self.waitForExpectationsWithTimeout(2, handler: nil) }
        
        let navigationController = UINavigationController()
        _navigationController = navigationController
        
        let viewController = UIViewController()
        navigationController.pushViewController(viewController, animated: false)
        
        print(navigationController.viewControllers)
        
        navigationController.rex_popToViewController.signal.observeNext { _ in
            expectation.fulfill()
        }
        
        navigationController.popToViewController(viewController, animated: false)
    }
}
