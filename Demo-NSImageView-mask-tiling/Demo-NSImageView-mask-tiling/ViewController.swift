//
//  ViewController.swift
//  Demo-NSImageView-mask-tiling
//
//  Created by Kristina Gelzinyte on 4/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let redView = NSView()
    let blueView = NSView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.wantsLayer = true
        blueView.layer?.backgroundColor = NSColor.blue.cgColor
        self.view.addSubview(blueView)
        
        redView.wantsLayer = true
        redView.layer?.backgroundColor = NSColor.red.cgColor
        self.view.addSubview(redView)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        blueView.frame = self.view.bounds
        redView.frame = self.view.bounds

        setupStarMask()
        setupCornerMask()
    }
    
    func setupStarMask() {
        let mask = CALayer()
        mask.contents = NSImage(named: "star.png")
        
        redView.layer?.mask = mask
        mask.frame = self.view.bounds
    }
    
    func setupCornerMask() {
        let mask = CALayer()

        let image = NSImage(named: "Corners")?.slicedImage(targetRect: self.view.bounds)
        mask.contents = image
        
        blueView.layer?.mask = mask
        mask.frame = self.view.bounds
    }
}

extension NSImage {
    func slicedImage(targetRect: NSRect) -> NSImage {
        let rect = NSRect(origin: .zero, size: targetRect.size)
        
        let resultImage = NSImage.init(size: rect.size)
        
        resultImage.lockFocus()
        self.draw(in: rect, from: NSRect(origin: .zero, size: self.size), operation: .copy, fraction: 1)
        resultImage.unlockFocus()
        
        return resultImage
    }
}
