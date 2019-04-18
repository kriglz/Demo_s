//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
let superView = views[0] as! NSView

let redView = NSView(frame: superView.bounds)
redView.wantsLayer = true
redView.layer?.backgroundColor = NSColor.red.cgColor
superView.addSubview(redView)

let maskView = NSImageView()
maskView.image = NSImage(named: "star.png")
maskView.wantsLayer = true

redView.layer?.mask = maskView.layer
maskView.frame = superView.bounds

PlaygroundPage.current.liveView = superView
