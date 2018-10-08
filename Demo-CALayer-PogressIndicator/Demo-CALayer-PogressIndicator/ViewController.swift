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
        
        for _ in 0...7 {
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
        
        lineLayer.lineWidth = 2
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

        let strokeAnimation = CAAnimationGroup()
        strokeAnimation.animations = [startAnimation, endAnimation]
        strokeAnimation.duration = duration + delay
        strokeAnimation.repeatCount = .infinity
        lineLayer.add(strokeAnimation, forKey: "strokeAnimation")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.byValue = -CGFloat.pi / 3
        rotationAnimation.duration = duration / 6
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .infinity
        
        lineLayer.add(rotationAnimation, forKey: rotationAnimation.keyPath)
        
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.toValue = UIColor.red.cgColor
        colorAnimation.duration = (duration + delay) / 2
        colorAnimation.autoreverses = true

        lineLayer.add(colorAnimation, forKey: colorAnimation.keyPath)
        
        let shadowColorAnimation = CABasicAnimation(keyPath: "shadowColor")
        shadowColorAnimation.toValue = UIColor.red.cgColor
        shadowColorAnimation.duration = (duration + delay) / 2
        shadowColorAnimation.autoreverses = true
        
        let strokeColorAnimation = CAAnimationGroup()
        strokeColorAnimation.animations = [colorAnimation, shadowColorAnimation]
        strokeColorAnimation.duration = duration + delay
        strokeColorAnimation.repeatCount = .infinity
        lineLayer.add(strokeColorAnimation, forKey: "strokeColorAnimation")
    }
}

