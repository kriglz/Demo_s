//
//  ViewController.swift
//  Demo-SlicedShadowImage
//
//  Created by Kristina Gelzinyte on 5/15/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private lazy var maskLayer: CALayer = {
        let layer = CALayer()
        let image = NSImage(named: "card")?.resized(targetSize: self.imageContainerView.bounds.size)
        layer.contents = image
        return layer
    }()
    
    private let imageContainerView = NSView()
    private let rewardImageView = NSView()
    let shadowView = NSImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageContainerView.wantsLayer = true
        self.imageContainerView.layer?.masksToBounds = true
        
        self.rewardImageView.wantsLayer = true
        self.rewardImageView.layer?.masksToBounds = true
        self.rewardImageView.layer?.backgroundColor = .white
        self.rewardImageView.layer?.contentsGravity = .resizeAspectFill
        
        self.rewardImageView.layer?.contents = NSImage(named: "image")
        
        self.imageContainerView.addSubview(self.rewardImageView)
        
        shadowView.imageScaling = .scaleAxesIndependently
        shadowView.image = NSImage(named: "shadow")
//        shadowView.wantsLayer = true

        self.view.addSubview(shadowView)
        self.view.addSubview(self.imageContainerView)

        self.imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.rewardImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.imageContainerView.heightAnchor.constraint(equalToConstant: 151).isActive = true
        self.imageContainerView.widthAnchor.constraint(equalToConstant: 131).isActive = true

        self.rewardImageView.leadingAnchor.constraint(equalTo: self.imageContainerView.leadingAnchor).isActive = true
        self.rewardImageView.trailingAnchor.constraint(equalTo: self.imageContainerView.trailingAnchor).isActive = true
        self.rewardImageView.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor).isActive = true
        self.rewardImageView.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor).isActive = true

        shadowView.leadingAnchor.constraint(equalTo: self.imageContainerView.leadingAnchor, constant: -14).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.imageContainerView.trailingAnchor, constant: 14).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor, constant: -10).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor, constant: 18).isActive = true
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.maskLayer.frame = self.imageContainerView.bounds
        self.imageContainerView.layer?.mask = self.maskLayer
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
//        self.shadowView.layer?.contentsScale = NSScreen.main?.backingScaleFactor ?? 1
        
        
        print(self.shadowView.image)
        print(self.shadowView.layer?.contentsScale)
        print(NSScreen.main?.backingScaleFactor)
    }
}

private extension NSImage {
    func resized(targetSize size: CGSize) -> NSImage {
        if size.width == 0 || size.height == 0 {
            return self
        }
        
        let targetRect = NSRect(origin: .zero, size: size)
        let sourceRect = NSRect(origin: .zero, size: self.size)
        
        let resultImage = NSImage(size: size)
        
        resultImage.lockFocus()
        self.draw(in: targetRect, from: sourceRect, operation: .copy, fraction: 1)
        resultImage.unlockFocus()
        
        return resultImage
    }
}
