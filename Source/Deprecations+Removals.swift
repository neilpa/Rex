//
//  Deprecations+Removals.swift
//  Rex
//
//  Created by Markus Chmelar on 30/10/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError
#if os(OSX)
import AppKit
extension NSTextField {
    @available(*, unavailable, renamed:"reactive.continuousStringValues")
    public var rex_textSignal: SignalProducer<String, NoError> { fatalError() }
}
#endif

extension NSObject {
    @available(*, unavailable, renamed:"reactive.lifetime.ended")
    public var rex_willDealloc: Signal<(), NoError> { fatalError() }
    
    @available(*, unavailable, renamed:"reactive.values(forKeyPath:)")
    public func rex_producerForKeyPath<T>(_ keyPath: String) -> SignalProducer<T, NoError> { fatalError() }
}

#if os(iOS)
import UIKit
//@available(*, unavailable, message: "Reusable protocol has been moved to ReactiveCocoa in RAC 5.0. UI Extensions have been moved to RAC 5.0")
//public protocol Reusable {
//    @available(*, unavailable, renamed:"reactive.prepareForReuse")
//    var rac_prepareForReuseSignal: RACSignal! { get }
//}

extension Reusable {
    @available(*, unavailable, renamed:"reactive.prepareForReuse")
    public var rex_prepareForReuse: Signal<Void, NoError> { fatalError() }
}
    
extension CocoaAction {
    @available(*, unavailable, renamed:"isEnabled")
    public var rex_enabledProducer: SignalProducer<Bool, NoError> { fatalError() }
    @available(*, unavailable, renamed:"isExecuting")
    public var rex_executingProducer: SignalProducer<Bool, NoError> { fatalError() }
}

extension UIActivityIndicatorView {
    @available(*, unavailable, renamed:"reactive.isAnimating")
    public var rex_animating: MutableProperty<Bool> { fatalError() }
    
}

extension UIBarButtonItem {
    @available(*, unavailable, renamed:"reactive.pressed")
    public var rex_action: MutableProperty<CocoaAction<Any>> { fatalError() }
}

extension UIBarItem {
    @available(*, unavailable, renamed:"reactive.isEnabled")
    public var rex_enabled: MutableProperty<Bool> { fatalError() }
}

extension UIButton {
    @available(*, unavailable, renamed:"reactive.pressed")
    public var rex_pressed: MutableProperty<CocoaAction<Any>> { fatalError() }
    @available(*, unavailable, renamed:"reactive.title")
    public var rex_title: MutableProperty<String> { fatalError() }
}

extension UIDatePicker {
    @available(*, unavailable, renamed:"reactive.date")
    public var rex_date: MutableProperty<NSDate> { fatalError() }
}

extension UIImageView {
    @available(*, unavailable, renamed:"reactive.image")
    public var rex_image: MutableProperty<UIImage?> { fatalError() }
    @available(*, unavailable, renamed:"reactive.highlightedImage")
    public var rex_highlightedImage: MutableProperty<UIImage?> { fatalError() }
}

extension UILabel {
    @available(*, unavailable, renamed:"reactive.text")
    public var rex_text: MutableProperty<String?> { fatalError() }
    @available(*, unavailable, renamed:"reactive.attributedText")
    public var rex_attributedText: MutableProperty<NSAttributedString?> { fatalError() }
    @available(*, unavailable, renamed:"reactive.textColor")
    public var rex_textColor: MutableProperty<UIColor> { fatalError() }
}
    
extension UIControl {
    @available(*, unavailable, renamed:"reactive.trigger(for:)")
    public func rex_controlEvents(_ events: UIControlEvents) -> SignalProducer<UIControl?, NoError> { fatalError() }
    @available(*, unavailable, renamed:"reactive.isEnabled")
    public var rex_enabled: MutableProperty<Bool> { fatalError() }
    @available(*, unavailable, renamed:"reactive.isSelected")
    public var rex_selected: MutableProperty<Bool> { fatalError() }
    @available(*, unavailable, renamed:"reactive.isHighlighted")
    public var rex_highlighted: MutableProperty<Bool> { fatalError() }
}

extension UIProgressView {
    @available(*, unavailable, renamed:"reactive.progress")
    public var rex_progress: MutableProperty<Float> { fatalError() }
}

extension UISegmentedControl {
    @available(*, unavailable, renamed:"reactive.selectedSegmentIndex")
    public var rex_selectedSegmentIndex: MutableProperty<Int> { fatalError() }
}

extension UISwitch {
    @available(*, unavailable, renamed:"reactive.isOn")
    public var rex_on: MutableProperty<Bool> { fatalError() }
}

extension UITextField {
    @available(*, unavailable, renamed:"reactive.text")
    public var rex_text: MutableProperty<String?> { fatalError() }
}

extension UITextView {
    @available(*, unavailable, renamed:"reactive.text")
    public var rex_text: SignalProducer<String, NoError> { fatalError() }
}

extension UIView {
    @available(*, unavailable, renamed:"reactive.alpha")
    public var rex_alpha: MutableProperty<CGFloat> { fatalError() }
    @available(*, unavailable, renamed:"reactive.isHidden")
    public var rex_hidden: MutableProperty<Bool> { fatalError() }
    @available(*, unavailable, renamed:"reactive.isUserInteractionEnabled")
    public var rex_userInteractionEnabled: MutableProperty<Bool> { fatalError() }
}
#endif
