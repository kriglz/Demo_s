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

    enum Position {
        case left
        case right
        case top
        case bottom
        case center

        func size(in rect: CGRect) -> CGSize {
            switch self {
            case .left, .right:
                return CGSize(width: ViewController.length, height: rect.height)
            case .top, .bottom:
                return CGSize(width: rect.width, height: ViewController.length)
            case .center:
                return CGSize(width: ViewController.length, height: ViewController.length)
            }
        }
    }
    
    static let length: CGFloat = 200

    let motionManager = CMMotionManager()
    let activeView = UIView()
    
    var direction = Position.center

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activeView.backgroundColor = .red
        activeView.frame = CGRect(x: 0, y: 0, width: ViewController.length, height: ViewController.length)

        activeView.layer.contents = UIImage(named: "lens")?.cgImage
        activeView.layer.contentsGravity = .resizeAspectFill
        
        view.addSubview(activeView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.squareMotion()
        self.cardFlipping()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func cardFlipping() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) { [unowned self] (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            let xGravity = CGFloat(data.gravity.x)
            let yGravity = CGFloat(data.gravity.y)

            print(xGravity)
            
            let rotationTransformX = CATransform3DMakeRotation(xGravity, 0, 1, 0)
            let rotationTransformY = CATransform3DMakeRotation(-yGravity, 1, 0, 0)

            self.activeView.layer.transform = CATransform3DConcat(rotationTransformX, rotationTransformY)
        }
    }
    
    private func squareMotion() {
        let center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        activeView.center = center
        
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) { [unowned self] (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            var newX = center.x
            var newY = center.y
            var newDirectionX = Position.center
            var newDirectionY = Position.center
            
            if data.gravity.x > 0.2 {
                newDirectionX = .right
                newX = self.view.frame.maxX - 0.5 * ViewController.length
            } else if data.gravity.x < -0.2 {
                newDirectionX = .left
                newX = 0.5 * ViewController.length
            }
            
            if data.gravity.y > 0.2 {
                newDirectionY = .top
                newY = 0.5 * ViewController.length
            } else if data.gravity.y < -0.2 {
                newDirectionY = .bottom
                newY = self.view.frame.maxY - 0.5 * ViewController.length
            }
            
            if (newDirectionY == .center && newDirectionX != .center) {
                self.direction = newDirectionX
            } else if (newDirectionY != .center && newDirectionX == .center ) {
                self.direction = newDirectionY
            } else {
                self.direction = .center
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.activeView.center.x = newX
                self.activeView.center.y = newY
                self.activeView.bounds.size = self.direction.size(in: self.view.bounds)
                
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    //                    self.activeView.bounds.size = self.direction.size(in: self.view.bounds)
                })
            })
        }
    }
}

