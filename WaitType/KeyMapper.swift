//
//  KeyMapper.swift
//  WaitType
//
//  Created by Andrian Budantsov on 10/30/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//
//
//  Use of this source code is governed by MIT license
//  that can be found in the LICENSE file.
//

import Foundation

struct KeyPress {
    let shift: Bool
    let code: CGKeyCode
}

struct KeyMapper {

    var keyToString: [String: KeyPress] = KeyMapper.fillTable()

    var hasASCII: Bool {
        return keyToString["a"] != nil
    }

    mutating public func refresh() {
        keyToString = KeyMapper.fillTable()
    }

    public func keyPress(_ ascii: UInt8) -> KeyPress? {
        guard let str = String(bytes: [ascii], encoding: .ascii) else {
            return nil
        }
        return keyToString[str]
    }

    private static func fillTable() -> [String: KeyPress] {
        var t: [String: KeyPress] = [:]

        for shift in [false, true] {
            for i in 0..<128 {
                let k = CGKeyCode.init(i)
                if let cfs = CreateStringForKeyCodeAndShift(k, shift) {
                    let str = cfs.takeRetainedValue() as String
                    if t[str] == nil {
                        t[str] = KeyPress.init(shift: shift, code: k)
                    }
                }
            }
        }

        return t
    }

}
