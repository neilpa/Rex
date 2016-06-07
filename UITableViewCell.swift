//
//  UITableViewCell.swift
//  Rex
//
//  Created by David Rodrigues on 19/04/16.
//  modified by Andrew Ware on 6/7/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit

extension UITableViewCell: Reusable {
    
    /// Wraps a UITableViewCell's `userInteractionEnabled` value in a bindable property.
    public var rex_userInteractionEnabled: MutableProperty<Bool> {
        return associatedProperty(self, key: &userInteractionEnabledKey, initial: { $0.userInteractionEnabled }, setter: { $0.userInteractionEnabled = $1 })
    }
    
}

private var userInteractionEnabledKey: UInt8 = 0
