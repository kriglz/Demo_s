//
//  ProgressIndicator.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    
    var progress: Float = 0 {
        didSet {
            indicatorView.progress = progress
        }
    }
    
    private let lineWidth: CGFloat = 7
    
    private let backgroundView = BackgroundView()
    private let indicatorView = IndicatorView()
    private let placeholderIconView = UserPlaceholderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        indicatorView.lineWidth = lineWidth
        
        addSubview(backgroundView)
        addSubview(indicatorView)
        addSubview(placeholderIconView)
     
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        placeholderIconView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        indicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        placeholderIconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        placeholderIconView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50).isActive = true
        placeholderIconView.heightAnchor.constraint(equalTo: placeholderIconView.widthAnchor).isActive = true
        placeholderIconView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 301).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.path = circleClipPath(small: false, inner: true)
        indicatorView.path = circlePath(small: false, inner: false)
        
        indicatorView.alpha = 0 // hide at first
    }
    
    func circleClipPath(small: Bool, inner: Bool) -> CGPath {
        let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        
        let scaleCoefficient: CGFloat = small ? 0.134 : 0.424
        let offsetCoefficient: CGFloat = inner ? 0.5 * lineWidth : 0
        
        let rect = CGRect(x: 25,
                          y: (bounds.height - safeAreaInsets.top - safeAreaInsets.bottom) * 0.187,
                          width: bounds.width - 50,
                          height: 0.444 * (bounds.height - safeAreaInsets.top - safeAreaInsets.bottom) )
        
        let radius = rect.width * scaleCoefficient - offsetCoefficient //scaleCoefficient * bounds.size.width - offsetCoefficient
        let center = CGPoint(x: rect.midX, y: rect.midY) //CGPoint(x: bounds.midX, y: bounds.height * 0.43 + safeAreaInsets.top)
        
        let startAngle = 0.5 * CGFloat.pi
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle - 2 * CGFloat.pi, clockwise: false)
        
        bezierPath.append(circlePath)
        bezierPath.usesEvenOddFillRule = true
        
        return bezierPath.cgPath
    }
    
    func circlePath(small: Bool, inner: Bool) -> CGPath {
        let scaleCoefficient: CGFloat = small ? 0.134 : 0.424
        let offsetCoefficient: CGFloat = inner ? 0.5 * lineWidth : 0
        
        let rect = CGRect(x: 25,
                          y: (bounds.height - safeAreaInsets.top - safeAreaInsets.bottom) * 0.187,
                          width: bounds.width - 50,
                          height: 0.444 * (bounds.height - safeAreaInsets.top - safeAreaInsets.bottom) )
        
        let radius = rect.width * scaleCoefficient - offsetCoefficient //scaleCoefficient * bounds.size.width - offsetCoefficient
        let center = CGPoint(x: rect.midX, y: rect.midY) //CGPoint(x: bounds.midX, y: bounds.height * 0.43 + safeAreaInsets.top)
        
        let startAngle = 0.5 * CGFloat.pi
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle - 2 * CGFloat.pi, clockwise: false)
        
        return circlePath.cgPath
    }
}
