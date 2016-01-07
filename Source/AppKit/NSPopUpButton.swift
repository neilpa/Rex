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
}

private var indexOfSelectedItemKey: UInt8 = 0
private var titleKey: UInt8 = 0
private var attributedTitleKey: UInt8 = 0