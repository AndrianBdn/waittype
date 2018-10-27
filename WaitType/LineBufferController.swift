//
//  LineBufferController.swift
//  WaitType
//
//  Created by Andrian Budantsov on 10/25/18.
//  Copyright © 2018 Andrian Budantsov. All rights reserved.
//

import Cocoa

class LineBufferController {
    
    var textField : NSTextField
    let maxLines : Int
    var lineBuffer : [String]

    var string : String {
        return lineBuffer.joined(separator: "\n")
    }
    
    init(maxLines : Int, textField: NSTextField) {
        self.maxLines = maxLines
        self.textField = textField
        lineBuffer = []
    }
    
    func clear() {
        lineBuffer.removeAll()
        textField.stringValue = self.string
    }
    
    func print(_ text: String) {
        if lineBuffer.count == 0 {
            print(ln: text)
        }
        else {
            lineBuffer[lineBuffer.count - 1] += text
        }
        textField.stringValue = self.string
    }
    
    func print(ln : String) {
        lineBuffer.append(ln)
        if lineBuffer.count > maxLines {
            lineBuffer.removeFirst()
        }
        textField.stringValue = self.string 
    }
    
}
