//
//  ViewController.swift
//  Demo-NSScrollView-scroll
//
//  Created by Kristina Gelzinyte on 4/23/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let scrollView = NSScrollView()
    
    lazy var button: NSButton = {
        let button = NSButton()
        button.title = "Scroll"
        button.target = self
        button.action = #selector(self.scroll)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didFinishScroll),
                                               name: NSScrollView.boundsDidChangeNotification,
                                               object: nil)
        
        let image = NSImage(named: "dog")!
        let imageView = NSImageView(image: image)
        
        self.scrollView.hasVerticalScroller = false
        self.scrollView.hasHorizontalScroller = true

        self.scrollView.documentView = imageView
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.button)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.button.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.scrollView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(greaterThanOrEqualTo: self.scrollView.leadingAnchor).isActive = true
    }
    
    @objc func scroll() {
        let currentPoint = self.scrollView.contentView.bounds.origin
        print(currentPoint)
        
        var newPoint = currentPoint
        newPoint.x += 10
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.5
        
        self.scrollView.contentView.animator().setBoundsOrigin(newPoint)
        self.scrollView.reflectScrolledClipView(self.scrollView.contentView)
        
        NSAnimationContext.endGrouping()
        
        print(newPoint)
        print("\n\n")
    }
    
    @objc func didFinishScroll() {
        print("didFinishScroll\n\n")
    }
}

