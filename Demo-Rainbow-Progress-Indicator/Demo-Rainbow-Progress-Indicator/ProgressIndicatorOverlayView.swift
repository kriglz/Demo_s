//
//  ProgressIndicatorOverlayView.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ProgressIndicatorOverlayView: UIView {
    
    private let strokeWidth: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginTransparencyLayer(auxiliaryInfo: nil)
   
        context.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        context.addRect(bounds)
        context.fillPath()
        
        let circleRadius = 0.5 * bounds.size.width - 2 * strokeWidth
        let circleCenter = CGPoint(x: rect.midX, y: rect.height * 0.43)
            
        context.setLineWidth(strokeWidth)
        
        context.setBlendMode(.clear)
        context.addArc(center: circleCenter, radius: circleRadius + 0.5 * strokeWidth, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.fillPath()
        
        context.setBlendMode(.normal)
        context.setStrokeColor(UIColor.black.withAlphaComponent(0.35).cgColor)
        context.addArc(center: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        context.strokePath()
        
        context.endTransparencyLayer()
    }
}
