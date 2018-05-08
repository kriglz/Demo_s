//
//  TestWindow.swift
//  Demo
//
//  Created by Kristina Gelzinyte on 3/22/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class TestWindow: NSWindowController {
    
    let textField = NSTextField()
    
    override var windowNibName: NSNib.Name? {
        get {
            return NSNib.Name.init("TestWindow")
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.initialFirstResponder = self.textField
        
        self.window?.contentView?.addSubview(textField)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.textField.centerXAnchor.constraint(equalTo: (self.window?.contentView?.centerXAnchor)!).isActive = true
        self.textField.centerYAnchor.constraint(equalTo: (self.window?.contentView?.centerYAnchor)!).isActive = true
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        self.window?.close()
    }
}
