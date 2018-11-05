//
//  KeySender.swift
//  WaitType
//
//  Created by Andrian Budantsov on 10/27/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//
//  Use of this source code is governed by MIT license
//  that can be found in the LICENSE file.
//

import Foundation

typealias PromptSetter = (String) -> Void
typealias PromptEnabler = (Bool) -> Void

struct KeySender {

    let log: LineBufferController
    let setPrompt: PromptSetter
    let enablePrompt: PromptEnabler
    var mapper = KeyMapper()
    var secure: Bool = false

    init(log: LineBufferController, setPrompt : @escaping PromptSetter, enablePrompt : @escaping PromptEnabler) {
        self.log = log
        self.setPrompt = setPrompt
        self.enablePrompt = enablePrompt
    }

    mutating func refreshIfNeeded() {
        if mapper.hasASCII == false {
            mapper.refresh()
        }
    }

    public func sendText(text: String) {

        if text == "" {
            return
        }

        if mapper.hasASCII == false {
            log.print(ln: "Current keyboard layout does not have English letters")
            log.print(ln: "Won't be able to type anything...")
            return
        }

        setPrompt("typing in progress")
        enablePrompt(false)
        log.clear()
        log.print(ln: "Quick! Switch focus to target app!")
        log.print(ln: "")

        let m = DispatchQueue.main
        let startDelay = 5
        let letterDelay = 0.2

        for i in 1...startDelay {
            m.asyncAfter(deadline: DispatchTime.now() + Float64(i)) {
                self.log.print("\(i)...")
            }
        }

        for i in 0..<text.count {
            let afterTime = Float64(startDelay) + Float64(i+1) * letterDelay
            m.asyncAfter(deadline: DispatchTime.now() + afterTime) {
                let idx = text.index(text.startIndex, offsetBy: i)
                let key = text[idx]
                if self.secure {
                    self.log.print(ln: "type •")
                } else {
                    self.log.print(ln: "type \(key)")
                }
                self.sendKeystoke(key: "\(key)")
            }
        }

        let completeTime = Float64(startDelay) + Float64(text.count+1) * letterDelay

        m.asyncAfter(deadline: DispatchTime.now() + completeTime) {
            self.log.print(ln: "Done typing")
            self.setPrompt("")
            self.enablePrompt(true)
        }
    }

    private func sendKeystoke(key: String) {
        guard let c = key.first, let uc = c.unicodeScalars.first else {
            return
        }

        guard uc.isASCII else {
            log.print(ln: "Skipping Non-ASCII symbol \(key)")
            return
        }

        if let press = self.mapper.keyPress(UInt8(uc.value)) {
            press.perform()
        } else {
            log.print(ln: "Don't know how to simulate press of \(key)")
            return
        }
    }
}

// syntax suger for shift flag
extension CGEvent {
    var shift: Bool {
        get {
            return self.flags.contains(.maskShift)
        }
        set {
            if newValue {
                self.flags.insert(.maskShift)
            } else {
                self.flags.remove(.maskShift)
            }
        }
    }
}

extension KeyPress {
    func perform() {
        let keydown = CGEvent.init(keyboardEventSource: nil, virtualKey: code, keyDown: true)!
        let keyup = CGEvent.init(keyboardEventSource: nil, virtualKey: code, keyDown: false)!
        keyup.shift = shift
        keydown.shift = shift
        keydown.post(tap: .cghidEventTap)
        keyup.post(tap: .cghidEventTap)
    }
}
