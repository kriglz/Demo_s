//
//  ViewController.swift
//  Demo-CGPath-multipleColors
//
//  Created by Kristina Gelzinyte on 1/22/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var colorLayer: CAShapeLayer {
        let layer = CAShapeLayer()
        let width = CGFloat(100.0)
        let rect = CGRect(x: (self.view.frame.size.width - width) / 2,
                          y: (self.view.frame.size.height - width) / 2,
                          width: width,
                          height: width)
        layer.path = CGPath(ellipseIn: rect, transform: nil)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        return layer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorLayer()
    }
    
    func setupColorLayer() {
        let layer = ColorLayer()
        let width = CGFloat(100.0)
        layer.frame = CGRect(x: (self.view.frame.size.width - width) / 2,
                             y: (self.view.frame.size.height - width) / 2,
                             width: width,
                             height: width)
        self.view.layer.addSublayer(layer)
        
        layer.setNeedsDisplay()
    }
}

class ColorLayer: CAShapeLayer {
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        let path1 = UIBezierPath(ovalIn: self.bounds)
        path1.lineWidth = 2
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.addPath(path1.cgPath)
        ctx.drawPath(using: .fillStroke)

        let path2 = UIBezierPath(rect: self.bounds)
        path2.lineWidth = 5
        ctx.setStrokeColor(UIColor.green.cgColor)
        ctx.addPath(path2.cgPath)
        ctx.drawPath(using: .stroke)
    }
}
