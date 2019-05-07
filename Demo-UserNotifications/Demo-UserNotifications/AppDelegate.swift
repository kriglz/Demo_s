//
//  AppDelegate.swift
//  Demo-UserNotifications
//
//  Created by Kristina Gelzinyte on 5/6/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let alert = NSAlert()

        if let userInfo = aNotification.userInfo,
            let userNotification = userInfo[NSApplication.launchUserNotificationUserInfoKey] as? NSUserNotification {
            alert.messageText = "userNotification"
            alert.informativeText = "\(userNotification)"
        } else {
            alert.messageText = "applicationDidFinishLaunching"
        }
        
        alert.runModal()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            return false
        }
        
        NSApp.windows.first?.makeKeyAndOrderFront(self)
        return true
    }
}
