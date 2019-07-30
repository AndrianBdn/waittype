//
//  CopyPasteNSApplication.swift
//  WaitType
//
//  Created by Andrian Budantsov on 7/30/19.
//  Copyright © 2019 Andrian Budantsov. All rights reserved.
//

import Cocoa

private extension NSEvent.ModifierFlags {

    var commandOnly: Bool {
        return self.rawValue &
            NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue == NSEvent.ModifierFlags.command.rawValue
    }

    var commandShiftOnly: Bool {
        return self.rawValue &
            NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue ==
            NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue
    }
}

@objc(CopyPasteNSApplication) class CopyPasteNSApplication: NSApplication {

    private func commandPlus(key: String) -> Bool {
        switch key.lowercased() {
        case "x":
            return NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self)
        case "c":
            return NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self)
        case "v":
            return NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self)
        case "z":
            return NSApp.sendAction(Selector(("undo:")), to: nil, from: self)
        case "a":
            return NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self)
        default:
            break
        }
        return false
    }

    override func sendEvent(_ event: NSEvent) {
        if event.type == NSEvent.EventType.keyDown {
            if event.modifierFlags.commandOnly {
                if commandPlus(key: event.charactersIgnoringModifiers!) {
                    return
                }
            } else if event.modifierFlags.commandShiftOnly {
                if event.charactersIgnoringModifiers == "Z" {
                    if NSApp.sendAction(Selector(("redo:")), to: nil, from: self) {
                        return
                    }
                }
            }
        }

        super.sendEvent(event)
    }
}
