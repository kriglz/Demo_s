//
//  ViewController.swift
//  Demo-UserNotifications
//
//  Created by Kristina Gelzinyte on 5/6/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSUserNotificationCenterDelegate {

    let notificationCenter = NSUserNotificationCenter.default
    var fireDate: Date?
    
    let timeToFire = 5.0

    lazy var button: NSButton = {
        let button = NSButton()
        button.bezelStyle = .rounded
        button.keyEquivalent = "\r"
        button.title = "Schedule notification for \(self.timeToFire) sec"
        button.target = self
        button.action = #selector(self.scheduleNotification(_:))
        return button
    }()
    
    lazy var label: NSTextField = {
        let label = NSTextField(labelWithString: "00")
        label.drawsBackground = false
        return label
    }()

    var notification: NSUserNotification {
        let notification = NSUserNotification()
        notification.identifier = "Notification"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        notification.title = "Time has come!"
        notification.informativeText = "Claim it."

        notification.deliveryDate = NSDate(timeIntervalSinceNow: self.timeToFire) as Date
        
        notification.actionButtonTitle = "Open"
        
        return notification
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationCenter.delegate = self

        self.view.addSubview(self.button)
        self.view.addSubview(self.label)
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.label.centerXAnchor.constraint(equalTo: self.button.centerXAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.button.topAnchor, constant: -10).isActive = true
    }

    @objc func scheduleNotification(_ sender: NSButton) {
        self.notificationCenter.scheduleNotification(self.notification)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.fireDate == nil {
                self.fireDate = timer.fireDate
            }

            let delta =  Date().timeIntervalSince(self.fireDate!).rounded() + 1
            self.label.stringValue = "\(delta)"
            
            if delta >= self.timeToFire {
                timer.invalidate()
                self.fireDate = nil
            }
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch notification.activationType {
        case .actionButtonClicked:
            NSWorkspace.shared.launchApplication(withBundleIdentifier: "com.planner5d.Planner-5D.macOS",
                                                 options: .default,
                                                 additionalEventParamDescriptor: nil,
                                                 launchIdentifier: nil)
        default:
            break
        }
    }
}
