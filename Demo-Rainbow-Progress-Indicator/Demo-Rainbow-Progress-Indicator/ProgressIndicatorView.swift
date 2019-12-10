//
//  ProgressIndicator.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    
    private let strokeWidth: CGFloat = 10
    private let indicatorLayer = CAShapeLayer()
    private let indicatorView = UIView()
    private let rainbowView = UIImageView(image: UIImage(named: "rainbow.png"))

    var progress: Float = 0 {
        didSet {
            guard progress != oldValue else { return }
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.3
            animation.fromValue = indicatorLayer.presentation()?.value(forKeyPath: "strokeEnd") ?? 0
            animation.toValue = progress
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            indicatorLayer.removeAllAnimations()
            indicatorLayer.add(animation, forKey: "animateCircle")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
               
        indicatorLayer.lineWidth = strokeWidth
        indicatorLayer.fillColor = UIColor.clear.cgColor
        indicatorLayer.strokeColor = UIColor.black.cgColor
        
        indicatorLayer.strokeStart = 0
        indicatorLayer.strokeEnd = 0
        indicatorLayer.lineCap = .round
        
        rainbowView.contentMode = .scaleToFill
        
        addSubview(indicatorView)
        indicatorView.addSubview(rainbowView)

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        rainbowView.translatesAutoresizingMaskIntoConstraints = false

        indicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        rainbowView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rainbowView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rainbowView.heightAnchor.constraint(equalTo: rainbowView.widthAnchor).isActive = true
        rainbowView.topAnchor.constraint(equalTo: topAnchor, constant: 182).isActive = true
        
        rainbowView.rotate()
        
//        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: { [weak self] in
//            self?.rainbowView.transform = CGAffineTransform.init(rotationAngle: 2 * .pi)
//        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = 0.5 * bounds.size.width - 2 * strokeWidth
        let center = CGPoint(x: frame.midX, y: frame.height * 0.43)
        
        let bezierPath = UIBezierPath()
        let startAngle = 0.5 * CGFloat.pi
        bezierPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle - 2 * CGFloat.pi, clockwise: false)
        
        indicatorLayer.path = bezierPath.cgPath
        indicatorLayer.frame = bounds
        
        indicatorView.layer.mask = indicatorLayer
    }
    
//
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.beginTransparencyLayer(auxiliaryInfo: nil)
//
//
//        let startAngle = CGFloat(-Float.pi * 2 * 0.25)
//        let endAngle = CGFloat((Float.pi * 2 * (-0.25 + progress)))
//
//        context.setLineCap(.round)
//        context.setStrokeColor(UIColor.white.cgColor)
//        context.setLineWidth(strokeWidth)
//        context.addArc(center: circleCenter, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        context.strokePath()
//
//        context.endTransparencyLayer()
//    }
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
