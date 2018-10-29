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
    
    private func keyLower(_ k : UInt8) -> UInt8 {
        if k >= UInt8.init(ascii: "A") && k <= UInt8.init(ascii: "Z") {
            return k + 32
        }
        let nd : [UInt8] = Array("`0123456789,./[]".utf8)
        let ns : [UInt8] = Array("~)!@#$%^&*(<>?{}".utf8)
        
        
        if let idx = ns.firstIndex(where: { $0 == k }) {
            return nd[idx]
        }
        
        return k
    }
    
    
    private func sendKeystoke(key : String) {
        guard let c = key.first, let uc = c.unicodeScalars.first else {
            return
        }
        
        guard uc.isASCII else {
            log.print(ln: "Skipping Non-ASCII symbol \(key)")
            return
        }
        
        let ch = UInt8(uc.value)
        let lch = keyLower(ch)
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
