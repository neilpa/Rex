//
//  UITextField.swift
//  Rex
//
//  Created by Rui Peres on 17/01/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveCocoa
import UIKit
import enum Result.NoError

extension UITextField {
    
    /// Sends the field's string value whenever it changes.
    public var rex_text: SignalProducer<String, NoError> {
        return rex_controlEvents(.AllEditingEvents)
            .filterMap  { ($0 as? UITextField)?.text }
    }
}
