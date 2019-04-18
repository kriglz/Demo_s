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
    let mask = NSImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        redView.wantsLayer = true
        redView.layer?.backgroundColor = NSColor.red.cgColor
        self.view.addSubview(redView)

        mask.wantsLayer = true
        mask.image = NSImage(named: "star.png")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        redView.frame = self.view.bounds
        
        redView.layer?.mask = mask.layer
        mask.frame = self.view.bounds
        
//        self.view.addSubview(mask)
    }
}
