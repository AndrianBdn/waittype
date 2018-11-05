//
//  OptionalSecurityTextField.swift
//  WaitType
//
//  Created by Andrian Budantsov on 11/1/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//
//  Use of this source code is governed by MIT license
//  that can be found in the LICENSE file.
//

import Cocoa

class OptionalSecurityTextFieldManager {

    private let unsecureField: NSTextField
    private let secureField: NSTextField

    var secure: Bool = false {
        didSet {
            self.current.isHidden = false
            self.other.isHidden = true
            OptionalSecurityTextFieldManager.copyFieldProperties(old: self.other, new: self.current)
            self.current.becomeFirstResponder()
        }
    }

    private var current: NSTextField {
        if secure {
            return secureField
        } else {
            return unsecureField
        }
    }

    private var other: NSTextField {
        if secure {
            return unsecureField
        } else {
            return secureField
        }
    }

    var stringValue: String = "" {
        didSet {
            self.current.stringValue = stringValue
        }
    }

    var isEnabled: Bool = true {
        didSet {
            self.current.isEnabled = isEnabled
        }
    }

    init(unsecure: NSTextField, secure: NSTextField) {
        self.unsecureField = unsecure
        self.secureField = secure
        self.secureField.frame = self.unsecureField.frame
        defer {
            self.secure = false // to call secure.didSet 
        }
    }

    private static func copyFieldProperties(old: NSTextField, new: NSTextField) {
        new.stringValue = old.stringValue
        new.isEnabled = old.isEnabled
        new.placeholderString = old.placeholderString
    }

}

private func leftPad(rect: CGRect, pad: CGFloat) -> CGRect {
    return NSRect(x: rect.origin.x + pad,
                  y: rect.origin.y,
                  width: rect.size.width - pad,
                  height: rect.size.height)
}

class PaddedTextField: NSTextFieldCell {

    @IBInspectable var leftPadding: CGFloat = 10.0

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return super.drawingRect(forBounds: leftPad(rect: rect, pad: leftPadding))
    }

}

class PaddedSecureTextField: NSSecureTextFieldCell {

    @IBInspectable var leftPadding: CGFloat = 10.0

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return super.drawingRect(forBounds: leftPad(rect: rect, pad: leftPadding))
    }

}
