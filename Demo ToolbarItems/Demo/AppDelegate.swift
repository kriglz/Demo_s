//
//  AppDelegate.swift
//  Demo
//
//  Created by Kristina Gelzinyte on 3/22/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var windowController: TestWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {     
    }
    
    @IBAction func openWindow(_ sender: Any) {
        if windowController == nil {
            windowController = TestWindow()
            windowController?.window?.delegate = self
        }
        
        self.windowController?.showWindow(NSApplication.shared.mainWindow)
    }
    
    func windowWillClose(_ notification: Notification) {
        if windowController != nil {
            windowController = nil
        }
    }
}

