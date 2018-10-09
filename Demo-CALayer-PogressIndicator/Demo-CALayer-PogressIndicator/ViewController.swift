//
//  ViewController.swift
//  Demo-CALayer-PogressIndicator
//
//  Created by Kristina Gelzinyte on 10/8/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        
        let lineLayer = LineLayer(path: CGPath(ellipseIn: rect, transform: nil))
        lineLayer.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        view.layer.addSublayer(lineLayer)
        
        let duration = 2.0
        let delay = 0.5
        let repeatCount = Float.infinity
        
        lineLayer.strokeAnimation(duration: duration, delay: delay, repeatCount: repeatCount)
        lineLayer.rotationAnimation(duration: duration, repeatCount: repeatCount)
        lineLayer.colorAnimation(duration: duration + delay, repeatCount: repeatCount)
    }
}
