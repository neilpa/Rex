//
//  NSPopUpButton+ReactiveExtensions.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2015-12-13.
//  Copyright © 2015 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension NSPopUpButton {

    public var rex_menuItemsBinding: ConsumerBinding<[NSMenuItem]> {
        return associatedObject(self, key: &menuItemsBindingKey) { button in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    button.removeAllItems()
                    v.forEach { button.menu?.addItem($0) }
                default:
                    button.displayPlaceholder(value)
                }
            }
        }
    }

    public var rex_selectedIndexBinding: ConsumerBinding<Int> {
        return associatedObject(self, key: &selectedIndexBindingKey) { button in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    button.selectItemAtIndex(v)
                    (button.cell as? NSPopUpButtonCell)?.menuItem = button.itemArray[v]
                    button.synchronizeTitleAndSelectedItem()
                default:
                    button.displayPlaceholder(value)
                }
            }
        }
    }
    
    public var rex_selectedTagBinding: ConsumerBinding<Int> {
        return associatedObject(self, key: &selectedTagBindingKey) { button in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    button.selectItemWithTag(v)
                default:
                    button.displayPlaceholder(value)
                }
            }
        }
    }
    
    var rex_menuItemBinding: ConsumerBinding<NSMenuItem> {
        return associatedObject(self, key: &menuItemBindingKey) { button in
            ConsumerBinding() { value in
                switch value {
                case let .Value(v):
                    (button.cell as? NSPopUpButtonCell)?.menuItem = v
                default:
                    button.displayPlaceholder(value)
                }
            }
        }
    }
    
    // MARK: Private API
    
    /// Displays the placeholder text for the provided value. 
    ///
    /// - precondition: `placeholder` must specify a placeholder `BindingValue`
    private func displayPlaceholder<T>(placeholder: BindingValue<T>) {
        precondition(placeholder.isPlaceholder, "displayPlaceholder must be called with a placeholder value.")
        
        let controlSize = self.cell?.controlSize ?? .RegularControlSize
        let font = NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(controlSize))
        
        let placeholder = placeholder.formatString({ _ in return "" })
        
        let disabledColor: NSColor
        if #available(OSX 10.10, *) {
            disabledColor = NSColor.tertiaryLabelColor()
        } else {
            disabledColor = NSColor.blackColor().colorWithAlphaComponent(0.5)
        }
        
        let attrs = [NSForegroundColorAttributeName : disabledColor, NSFontAttributeName : font]
        
        let menuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        menuItem.attributedTitle = NSAttributedString(string: placeholder, attributes: attrs)
        (self.cell as? NSPopUpButtonCell)?.menuItem = menuItem
    }
}

private var selectedIndexBindingKey: UInt8 = 0
private var selectedTagBindingKey: UInt8 = 0
private var menuItemBindingKey: UInt8 = 0
private var menuItemsBindingKey: UInt8 = 0