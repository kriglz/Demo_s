//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport

let containerView = NSView(frame: NSRect(origin: .zero, size: CGSize(width: 500, height: 600)))
containerView.wantsLayer = true
containerView.layer?.backgroundColor = NSColor.white.cgColor

let image = NSImage(named: "vilnius.jpg")!
let imageView = NSImageView()
let layer = CALayer()

let desiredScaleFactor = containerView.window?.backingScaleFactor ?? 1
let actualScaleFactor = image.recommendedLayerContentsScale(desiredScaleFactor)
let layerContents = image.layerContents(forContentsScale: actualScaleFactor)

layer.contents = layerContents
layer.contentsScale = actualScaleFactor

imageView.wantsLayer = true

imageView.layer = layer
imageView.layer?.cornerRadius = 20
imageView.layer?.contentsGravity = .resizeAspectFill

containerView.addSubview(imageView)
imageView.translatesAutoresizingMaskIntoConstraints = false

imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true

PlaygroundPage.current.liveView = containerView
