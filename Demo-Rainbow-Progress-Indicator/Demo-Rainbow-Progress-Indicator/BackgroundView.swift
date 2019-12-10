//
//  ProgressIndicatorOverlayView.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
        
    var path: CGPath? {
        didSet {
            overlayLayer.path = path
        }
    }
    
    private let overlayLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        overlayLayer.fillRule = .evenOdd
        overlayLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        layer.addSublayer(overlayLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    
//    func animatePath(_ path: CGPath, duration: TimeInterval) {
//        let animation = CASpringAnimation(keyPath: "path")
//        
//        animation.damping = 5
//        animation.toValue = path
//        animation.duration = duration
//        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        animation.fillMode = .both
//        animation.isRemovedOnCompletion = false
//        
//        overlayLayer.add(animation, forKey: animation.keyPath)
//    }
}
