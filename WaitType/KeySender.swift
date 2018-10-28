//
//  KeySender.swift
//  WaitType
//
//  Created by Andrian Budantsov on 10/27/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//

import Foundation

typealias PromptSetter = (String) -> Void
typealias PromptEnabler = (Bool) -> Void

// syntax suger for shift flag
extension CGEvent {
    var shift : Bool {
        get {
            return self.flags.contains(.maskShift)
        }
        set {
            if (newValue) {
                self.flags.insert(.maskShift)
            } else {
                self.flags.remove(.maskShift)
            }
        }
    }
}

struct KeySender {
    
    let log : LineBufferController
    let setPrompt : PromptSetter
    let enablePrompt : PromptEnabler
    
    public func sendText(text : String) {
        
        if text == "" {
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
                self.log.print(ln: "type \(key)")
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
    
    private func sendKeystoke(key : String) {
        guard let c = key.first, let uc = c.unicodeScalars.first else {
            return
        }
        
        guard uc.isASCII else {
            log.print(ln: "Skipping Non-ASCII symbol \(key)")
            return
        }
        
        let ch = Int8(uc.value)
        let lch = char_tolower(ch)
        let pressShift = ch != lch;
        let code = keyCodeForChar(lch)
        
        if code == UInt16.max {
            log.print(ln: "Don't know how to simulate press of \(key)")
            return
        }
        
        self.press(code, shift: pressShift)
    }
    
    private func press(_ code : CGKeyCode, shift : Bool) {
        let keydown = CGEvent.init(keyboardEventSource: nil, virtualKey: code, keyDown: true)!
        let keyup = CGEvent.init(keyboardEventSource: nil, virtualKey: code, keyDown: false)!
        keyup.shift = shift
        keydown.shift = shift
        keydown.post(tap: .cghidEventTap)
        keyup.post(tap: .cghidEventTap)
    }
}
