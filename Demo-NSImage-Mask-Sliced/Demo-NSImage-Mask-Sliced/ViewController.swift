//
//  ViewController.swift
//  Demo-NSImage-Mask-Sliced
//
//  Created by Kristina Gelzinyte on 5/28/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    private let imageContainerView = NSView()
    private let rewardImageView = NSView()
    
    private  lazy var maskLayer: CALayer = {
        let layer = CALayer()
        let image = NSImage(named: "MaskImage")?.resized(targetSize: self.imageContainerView.bounds.size)
        layer.contents = image
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageContainerView.wantsLayer = true
        self.imageContainerView.layer?.masksToBounds = true
        
        self.rewardImageView.wantsLayer = true
        self.rewardImageView.layer?.masksToBounds = true
        self.rewardImageView.layer?.backgroundColor = .white
        self.rewardImageView.layer?.contentsGravity = .resizeAspectFill
        self.rewardImageView.layer?.contents = NSImage(named: "InputImage")?.resized(targetSize: self.imageContainerView.bounds.size)

        self.imageContainerView.addSubview(self.rewardImageView)
        self.view.addSubview(self.imageContainerView)
        
        self.makeConstraints()
    }

    private func makeConstraints() {
        self.imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.rewardImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageContainerView.constraint(edgesTo: self.view, constant: 50)
        self.rewardImageView.constraint(edgesTo: self.imageContainerView)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.maskLayer.frame = self.imageContainerView.bounds
        self.imageContainerView.layer?.mask = self.maskLayer
    }
}

extension NSImage {
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


extension NSView {
    @discardableResult func constraint(edgesTo superview: NSView, priority: NSLayoutConstraint.Priority = .required, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant))
        constraints.append(self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant))
        constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant))
        constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant))
        
        constraints.forEach { $0.priority = priority }
        
        NSLayoutConstraint.activate(constraints)
        
        return constraints
    }
}
