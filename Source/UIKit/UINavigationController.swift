//
//  UINavigationController.swift
//  Rex
//
//  Created by Rui Peres on 22/04/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import enum Result.NoError
import ReactiveCocoa
import UIKit

extension UINavigationController {
    
    /// Wraps a navigationViewController's `popViewControllerAnimated` function in a bindable property.
    /// It mimics the same input as `popViewControllerAnimated`: a `Bool` flag for the animation
    /// E.g:
    /// ```
    /// //Pop ViewController with animation (`true`)
    /// navigationController.rex_popViewController <~ aProducer.map { _ in true }
    /// ```
    /// The pop observation can be made either with binding (example above)
    /// or `viewController.popViewControllerAnimated(true)`
    public var rex_popViewController: MutableProperty<Bool?> {
        
        let initial: UINavigationController -> Bool? = { _ in nil }
        let setter: (UINavigationController, Bool?) -> Void  = { host, animated in
            
            guard let unwrapped = animated else { return }
            host.popViewControllerAnimated(unwrapped)
        }
        
        let property = associatedProperty(self, key: &popViewController, initial: initial, setter: setter)
        
        property <~ rac_signalForSelector(#selector(UINavigationController.popViewControllerAnimated(_:)))
            .takeUntilBlock { _ in property.value != nil }
            .rex_toTriggerSignal()
            .map { _ in return nil }
        
        return property
    }
    
    /// Wraps a navigationViewController's `popToRootViewControllerAnimated` function in a bindable property.
    public var rex_popToRootViewController: MutableProperty<Bool?> {
        
        let initial: UINavigationController -> Bool? = { _ in nil }
        let setter: (UINavigationController, Bool?) -> Void  = { host, animated in
            
            guard let unwrapped = animated else { return }
            host.popToRootViewControllerAnimated(unwrapped)
        }
        
        let property = associatedProperty(self, key: &popToRootViewController, initial: initial, setter: setter)
        
        property <~ rac_signalForSelector(#selector(UINavigationController.popToRootViewControllerAnimated(_:)))
            .takeUntilBlock { _ in property.value != nil }
            .rex_toTriggerSignal()
            .map { _ in return nil }
        
        return property
    }
    
    public typealias PopToViewController = (viewController: UIViewController, animated: Bool)?
    
    /// Wraps a navigationViewController's `popToViewController` function in a bindable property.
    public var rex_popToViewController: MutableProperty<PopToViewController> {
        
        let initial: UINavigationController -> PopToViewController = { _ in nil }
        let setter: (UINavigationController, PopToViewController) -> Void  = { host, popToViewController in
            
            guard let unwrapped = popToViewController else { return }
            host.popToViewController(unwrapped.viewController, animated: unwrapped.animated)
        }
        
        let property = associatedProperty(self, key: &popToViewControllerKey, initial: initial, setter: setter)
        
        property <~ rac_signalForSelector(#selector(UINavigationController.popToViewController(_:animated:)))
            .takeUntilBlock { _ in property.value != nil }
            .rex_toTriggerSignal()
            .map { return nil }
        
        return property
    }
}

private var popViewController: UInt8 = 0
private var popToRootViewController: UInt8 = 0
private var popToViewControllerKey: UInt8 = 0 // can't use `popToViewController` because it conflitcts with `UINavigationController`'s `popToViewController`