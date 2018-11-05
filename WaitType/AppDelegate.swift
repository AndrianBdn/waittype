//
//  AppDelegate.swift
//  WaitType
//
//  Created by Andrian Budantsov on 10/24/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//
//  Use of this source code is governed by MIT license
//  that can be found in the LICENSE file.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var secureTextField: NSTextField!
    @IBOutlet weak var unsecureTextField: NSTextField!

    var textField: OptionalSecurityTextFieldManager!
    @IBOutlet weak var textLog: NSTextField!
    @IBOutlet weak var secureMenu: NSMenuItem!

    var log: LineBufferController!
    var keySender: KeySender!
    let secureEntrySettingKey = "secureEntry"

    var secureEntry: Bool = false {
        didSet {
            guard oldValue != secureEntry else { return }

            textField.secure = secureEntry
            secureMenu.state = secureEntry ? .on : .off
            keySender.secure = secureEntry
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        secureTextField.focusRingType = .none
        unsecureTextField.focusRingType = .none
        secureTextField.frame = unsecureTextField.frame

        textField = OptionalSecurityTextFieldManager.init(unsecure: unsecureTextField, secure: secureTextField)

        window.styleMask.remove(.resizable)
        log = LineBufferController(maxLines: 7, textField: textLog)
        log.print(ln: "Paste text in the field and press Enter")

        keySender = KeySender(log: log, setPrompt: {
            self.textField.stringValue = $0
        }, enablePrompt: {
            self.textField.isEnabled = $0
        })

        self.secureEntry = UserDefaults.standard.bool(forKey: secureEntrySettingKey)

    }

    @IBAction func secureEntryToggle(sender: NSMenuItem) {
        self.secureEntry = !self.secureEntry
        UserDefaults.standard.set(self.secureEntry, forKey: secureEntrySettingKey)
    }

    @IBAction func textFieldAction(sender: NSTextField) {
        keySender.refreshIfNeeded()
        keySender.sendText(text: sender.stringValue)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
