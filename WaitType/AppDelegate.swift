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
    @IBOutlet weak var textField : NSTextField!
    @IBOutlet weak var textLog : NSTextField!

    var log : LineBufferController!
    var keySender : KeySender!

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        textField.focusRingType = .none
        window.styleMask.remove(.resizable)
        log = LineBufferController(maxLines: 7, textField: textLog)
        log.print(ln: "Paste text in the field and press Enter")
        
        keySender = KeySender(log: log, setPrompt: {
            self.textField.stringValue = $0
        }, enablePrompt: {
            self.textField.isEnabled = $0
        })
    }
    
    @IBAction func textFieldAction(sender: NSTextField) {
        keySender.sendText(text: sender.stringValue)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

