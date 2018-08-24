//
//  CGPoint+Extension.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension CGPoint {
    
    /// Returns distance between two points.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
    
    /// Retrurns CGPoint divided by specified value.
    func divide(by value: CGFloat) -> CGPoint {
        return CGPoint(x: x / value, y: y / value)
    }
}