// this is a code from https://stackoverflow.com/questions/38137824/nstextfield-padding-on-the-left
import Cocoa

class PaddedTextField: NSTextFieldCell {
    
    @IBInspectable var leftPadding: CGFloat = 10.0
    
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        let rectInset = NSMakeRect(rect.origin.x + leftPadding, rect.origin.y, rect.size.width - leftPadding, rect.size.height)
        return super.drawingRect(forBounds: rectInset)
    }
}
