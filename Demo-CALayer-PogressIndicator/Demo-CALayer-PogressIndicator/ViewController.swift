//
//  ViewController.swift
//  Demo-CALayer-PogressIndicator
//
//  Created by Kristina Gelzinyte on 10/8/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for _ in 0...15 {
            lineAnimation()
        }
    }

    private func lineAnimation() {
        let width = CGFloat.random(in: view.frame.width - 250...view.frame.width - 200)
        let rect = CGRect(x: -width / 2,
                          y: -width / 2,
                          width: width,
                          height: width)
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = CGPath(ellipseIn: rect, transform: nil)
        
        lineLayer.lineWidth = 1
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.blue.cgColor
        
        lineLayer.shadowColor = lineLayer.strokeColor
        lineLayer.shadowOffset = .zero
        lineLayer.shadowRadius = 4
        lineLayer.shadowOpacity = 1
        lineLayer.masksToBounds = false
        
        lineLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lineLayer.anchorPointZ = 0.5
        lineLayer.position = view.center
        
        view.layer.addSublayer(lineLayer)
        
        let duration = 2.0
        let delay = 0.5
        
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 1
        startAnimation.toValue = 0
        startAnimation.duration = duration
        startAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        startAnimation.isRemovedOnCompletion = false
        startAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 1
        endAnimation.toValue = 0
        endAnimation.duration = duration
        endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        endAnimation.beginTime = startAnimation.beginTime + delay

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.byValue = -CGFloat.pi / 3
        rotationAnimation.duration = duration / 6
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.isCumulative = true
        rotationAnimation.fillMode = .forwards
        rotationAnimation.repeatCount = .infinity
        
        let show = CAAnimationGroup()
        show.animations = [startAnimation, endAnimation]
        show.duration = duration + delay
        show.repeatCount = .infinity
        lineLayer.add(show, forKey: "show")
        
        lineLayer.add(rotationAnimation, forKey: rotationAnimation.keyPath)
    }
}

