//
//  NSPopUpButton.swift
//  Rex
//
//  Created by Christopher Liscio on 1/7/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import Foundation
import AppKit
import ReactiveCocoa

extension NSPopUpButton {
    public var rex_indexOfSelectedItem: MutableProperty<Int> {
        return associatedProperty(self, key: &indexOfSelectedItemKey, initial: { $0.indexOfSelectedItem }, setter: { $0.selectItemAtIndex($1) } )
    }
    
    public var rex_title: MutableProperty<String> {
        return associatedProperty(self, key: &titleKey, initial: { $0.title }, setter: { $0.setTitle($1) })
    }
    
    public var rex_attributedTitle: MutableProperty<NSAttributedString> {
        return associatedProperty(self, key: &attributedTitleKey,
            initial: { $0.attributedTitle },
            setter: {
                let menuItem = NSMenuItem(title: $1.string, action: nil, keyEquivalent: "")
                menuItem.attributedTitle = $1
                ($0.cell as? NSPopUpButtonCell)?.menuItem = menuItem
            })
    }
    
    public var rex_selectedIndexAction: Action<NSPopUpButton, Int, NoError> {
        return associatedObject(self, key: &selectedIndexActionKey) { _ in Action<NSPopUpButton, Int, NoError> { SignalProducer(value: $0.indexOfSelectedItem) } }
    }
    
    public var rex_selectedIndexes: Signal<Int, NoError> {
        let cocoaAction = associatedObject(self, key: &selectedIndexKey) { CocoaAction($0.rex_selectedIndexAction) { $0 as! NSPopUpButton } }
        rex_action.value = cocoaAction
        
        return rex_selectedIndexAction.values
    }
    
    public var rex_selectedTagAction: Action<NSPopUpButton, Int, NoError> {
        return associatedObject(self, key: &selectedTagActionKey) { _ in Action<NSPopUpButton, Int, NoError> { SignalProducer(value: $0.selectedTag()) } }
    }
    
    public var rex_selectedTags: Signal<Int, NoError> {
        let cocoaAction = associatedObject(self, key: &selectedTagKey) { CocoaAction($0.rex_selectedTagAction) { $0 as! NSPopUpButton } }
        rex_action.value = cocoaAction
        
        return rex_selectedTagAction.values
    }
}

private var indexOfSelectedItemKey: UInt8 = 0
private var titleKey: UInt8 = 0
private var attributedTitleKey: UInt8 = 0
private var selectedIndexKey: UInt8 = 0
private var selectedIndexActionKey: UInt8 = 0
private var selectedTagKey: UInt8 = 0
private var selectedTagActionKey: UInt8 = 0