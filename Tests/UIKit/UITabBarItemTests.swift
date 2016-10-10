//
//  UITabBarItemTests.swift
//  Rex
//
//  Created by Rafael Aroxa on 10/10/16.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit
import XCTest
import enum Result.NoError

class UITabBarItemTests: XCTestCase {
    
    func testEnabledProperty() {
        let tabBarItem = UITabBarItem()
        tabBarItem.enabled = true
        
        let (signal, observer) = Signal<Bool, NoError>.pipe()
        tabBarItem.rex_enabled <~ SignalProducer(signal: signal)
        
        observer.sendNext(false)
        XCTAssertFalse(tabBarItem.enabled)
        observer.sendNext(true)
        XCTAssertTrue(tabBarItem.enabled)
    }
    
    func testTitleProperty() {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = nil
        
        let (signal, observer) = Signal<String?, NoError>.pipe()
        tabBarItem.rex_title <~ SignalProducer(signal: signal)
        
        observer.sendNext("My Title")
        XCTAssertEqual(tabBarItem.title, "My Title")
        observer.sendNext(nil)
        XCTAssertNil(tabBarItem.title)
    }
}
