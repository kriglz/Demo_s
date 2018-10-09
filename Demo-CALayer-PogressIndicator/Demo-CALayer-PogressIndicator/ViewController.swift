//
//  ViewController.swift
//  Demo-CALayer-PogressIndicator
//
//  Created by Kristina Gelzinyte on 10/8/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let lineLayer = LineLayer(hasShadow: true)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for _ in 0...7 {
            lineAnimation()
        }
        
        randomLine()

        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(randomLine), userInfo: nil, repeats: true)
    }

    private func lineAnimation() {
        let width = CGFloat.random(in: view.frame.width - 250...view.frame.width - 200)
        let rect = CGRect(x: -width / 2,
                          y: -width / 2,
                          width: width,
                          height: width)
        
        let lineLayer = LineLayer(path: CGPath(ellipseIn: rect, transform: nil), hasShadow: true)
        lineLayer.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        view.layer.addSublayer(lineLayer)
        
        let duration = 2.0
        let delay = 0.5
        let repeatCount = Float.infinity
        
        lineLayer.strokeAnimation(duration: duration, delay: delay, repeatCount: repeatCount)
        lineLayer.rotationAnimation(duration: duration, repeatCount: repeatCount)
        lineLayer.colorAnimation(duration: duration + delay, repeatCount: repeatCount)
    }
    
    @objc private func randomLine() {
        var randomInFrame: CGPoint {
            return CGPoint(x: CGFloat.random(in: 0...self.view.frame.width), y: CGFloat.random(in: 0...self.view.frame.height))
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: CGFloat.random(in: 0...self.view.frame.width), y: 0))
        bezierPath.addLine(to: randomInFrame)
        bezierPath.addLine(to: randomInFrame)
        bezierPath.addLine(to: CGPoint(x: CGFloat.random(in: 0...self.view.frame.width), y: self.view.frame.height))

        lineLayer.update(path: bezierPath.cgPath)
        view.layer.addSublayer(lineLayer)
        
        let duration = 1.5
        let delay = 0.5
        let repeatCount = Float.infinity
        
        lineLayer.strokeAnimation(duration: duration, delay: delay, repeatCount: repeatCount)
        lineLayer.colorAnimation(duration: duration + delay, repeatCount: repeatCount)
    }
}
