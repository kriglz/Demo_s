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
        // Do any additional setup after loading the view, typically from a nib.
        
        let layer = self.colorLayer
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
    }
}

