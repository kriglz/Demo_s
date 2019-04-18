//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

public class RedView: NSView {
    override init(frame: NSRect) {
        super.init(frame: frame)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let superView = views[0] as! NSView

let redView = RedView(frame: superView.bounds)
superView.addSubview(redView)

let maskView = NSImageView()
let image = NSImage(named: "star.png")
maskView.image = image
maskView.wantsLayer = true

redView.layer?.mask = maskView.layer
maskView.frame = superView.bounds

PlaygroundPage.current.liveView = superView
