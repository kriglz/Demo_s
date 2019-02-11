//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let view = NSView(frame: NSRect(origin: .zero, size: CGSize(width: 300, height: 400)))
view.wantsLayer = true
view.layer?.backgroundColor = NSColor.blue.cgColor

let gradientLayer = CAGradientLayer()
gradientLayer.frame = view.bounds

let black = NSColor.black.cgColor
let clear = NSColor.clear.withAlphaComponent(0.5).cgColor

gradientLayer.colors = [clear, black]
gradientLayer.locations = [0, 0.1]

view.layer?.mask = gradientLayer

//view.layer?.addSublayer(gradientLayer)
PlaygroundPage.current.liveView = view
