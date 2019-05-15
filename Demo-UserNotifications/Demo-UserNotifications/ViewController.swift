//
//  ViewController.swift
//  Demo-UserNotifications
//
//  Created by Kristina Gelzinyte on 5/6/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    static let timeToFire = 5.0

    var fireDate: Date?
    var userNotifications: UserNotification?
    
    lazy var fireButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = .rounded
        button.keyEquivalent = "\r"
        button.title = "Schedule notification for \(ViewController.timeToFire) sec"
        button.target = self
        button.action = #selector(self.scheduleNotification(_:))
        return button
    }()
    
    lazy var cleanupButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = .rounded
        button.title = "Cleanup"
        button.target = self
        button.action = #selector(self.cleanup(_:))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.fireButton)
        self.view.addSubview(self.cleanupButton)
        
        self.fireButton.translatesAutoresizingMaskIntoConstraints = false
        self.cleanupButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.fireButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.fireButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.cleanupButton.centerXAnchor.constraint(equalTo: self.fireButton.centerXAnchor).isActive = true
        self.cleanupButton.topAnchor.constraint(equalTo: self.fireButton.bottomAnchor, constant: 10).isActive = true
    }

    @objc func scheduleNotification(_ sender: NSButton) {
        self.userNotifications = UserNotification.shared
        self.userNotifications?.fire()
    }
    
    @objc func cleanup(_ sender: NSButton) {
        self.userNotifications = nil
    }
}

class UserNotification: NSObject, NSUserNotificationCenterDelegate {
    
    let notificationCenter = NSUserNotificationCenter.default

    static let shared = UserNotification()
    
    var notification: NSUserNotification {
        let notification = NSUserNotification()
        notification.identifier = "Notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notification.title = "Time has come!"
        notification.informativeText = "Claim it."
        
        notification.deliveryDate = NSDate(timeIntervalSinceNow: ViewController.timeToFire) as Date
        
        notification.actionButtonTitle = "Open"
        
        return notification
    }
    
    private override init() {
        super.init()
        self.notificationCenter.delegate = self
    }

    func fire() {
        self.notificationCenter.scheduleNotification(self.notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch notification.activationType {
        case .actionButtonClicked:
            if NSApp.windows.first!.isMiniaturized {
                NSApp.windows.first?.deminiaturize(self)
            }
            
            NSWorkspace.shared.launchApplication(withBundleIdentifier: "KG.Demo-UserNotifications",
                                                 options: .default,
                                                 additionalEventParamDescriptor: nil,
                                                 launchIdentifier: nil)
        default:
            break
        }
    }
}
