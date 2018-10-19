//
//  ViewController.swift
//  Demo-Vibration_AudioToolbox
//
//  Created by Kristina Gelzinyte on 10/19/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.setTitle("Vibrate", for: .normal)
        self.button.addTarget(self, action: #selector(vibrateAction(_:) ), for: .touchDown)
        
        self.view.addSubview(button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @objc func vibrateAction(_ button: UIButton) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))        
    }
}

