//
//  IndicatorView.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/10/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class IndicatorView: UIView {
        
    var path: CGPath? {
        didSet {
            indicatorBackgroundLayer.path = path
            backgroundLayer.path = path

            indicatorMaskLayer.path = path
            indicatorView.layer.mask = indicatorMaskLayer
        }
    }
    
    var progress: Float = 0 {
        didSet {
            guard progress != oldValue else { return }
                        
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.3
            animation.fromValue = indicatorMaskLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0
            animation.toValue = progress
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            indicatorMaskLayer.removeAllAnimations()
            indicatorMaskLayer.add(animation, forKey: "animateCircle")
        }
    }
    
    var lineWidth: CGFloat = 7 {
        didSet {
            indicatorMaskLayer.lineWidth = lineWidth
            indicatorBackgroundLayer.lineWidth = lineWidth
        }
    }
    
    private let indicatorMaskLayer = CAShapeLayer()
    private let indicatorView = UIView()
    private let indicatorBackgroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()

    private let rainbowView = UIImageView(image: UIImage(named: "rainbow"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicatorMaskLayer.fillColor = UIColor.clear.cgColor
        indicatorMaskLayer.strokeColor = UIColor.black.cgColor
        
        indicatorMaskLayer.strokeStart = 0
//        indicatorMaskLayer.strokeEnd = 0
        indicatorMaskLayer.lineCap = .round
        
        indicatorBackgroundLayer.fillColor = UIColor.clear.cgColor
        indicatorBackgroundLayer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor

        backgroundLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor

        rainbowView.contentMode = .scaleToFill

        indicatorView.clipsToBounds = true
        indicatorView.layer.masksToBounds = true

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(indicatorBackgroundLayer)
        
        addSubview(indicatorView)
        indicatorView.addSubview(rainbowView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        rainbowView.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        rainbowView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rainbowView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50).isActive = true
        rainbowView.heightAnchor.constraint(equalTo: rainbowView.widthAnchor).isActive = true
        rainbowView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 301).isActive = true
        
        indicatorView.alpha = 0
//        indicatorBackgroundLayer.opacity = 0

//        rainbowView.rotate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animatePath(_ path: CGPath, duration: TimeInterval) {
//        indicatorView.alpha = 1
//        indicatorBackgroundLayer.opacity = 1

        let pathAnimation = CABasicAnimation(keyPath: "path")

        pathAnimation.toValue = path
        pathAnimation.duration = duration
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        pathAnimation.fillMode = .both
        pathAnimation.isRemovedOnCompletion = false

        indicatorMaskLayer.add(pathAnimation, forKey: pathAnimation.keyPath)
        indicatorBackgroundLayer.add(pathAnimation, forKey: pathAnimation.keyPath)

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 0
        opacityAnimation.duration = duration * 0.1
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        opacityAnimation.fillMode = .both
        opacityAnimation.isRemovedOnCompletion = false
        
        backgroundLayer.add(opacityAnimation, forKey: opacityAnimation.keyPath)
    }
}

extension UIImageView {
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 10
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
}
