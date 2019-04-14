//
//  ViewController.swift
//  Demo-Gyroscope
//
//  Created by Kristina Gelzinyte on 4/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    let motionManager = CMMotionManager()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "Camera")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard motionManager.isDeviceMotionAvailable else {
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            let rotation = CGFloat(atan2(data.gravity.x, data.gravity.y)) - .pi
            self?.imageView.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopDeviceMotionUpdates()
    }
}

