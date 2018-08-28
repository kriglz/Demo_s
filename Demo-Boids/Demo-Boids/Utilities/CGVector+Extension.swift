//
//  CGVector+Extension.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension CGVector {
    
    /// Returns vector distnace.
    var length: CGFloat {
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    /// Returns angle in radians.
    var angleToNormal: CGFloat {
        let angle = atan2(dy, dx)
        return CGFloat(angle)
    }
    
    /// Returns normalized CGVector.
    var normalized: CGVector {
        let maxComponent = max(abs(dx), abs(dy))
        return self.divide(by: maxComponent)
    }
    
    /// Returns CGVector divided by specified value.
    func divide(by value: CGFloat) -> CGVector {
        return CGVector(dx: dx / value, dy: dy / value)
    }
    
    /// Returns CGVector multiplied by specified value.
    func multiply(by value: CGFloat) -> CGVector {
        return CGVector(dx: dx * value, dy: dy * value)
    }
    
    /// Returns CGVector added to specified value.
    func add(_ value: CGVector) -> CGVector {
        return CGVector(dx: dx + value.dx, dy: dy + value.dy)
    }
    
    /// Returns random vector from the range.
    static func random(min: CGFloat, max: CGFloat) -> CGVector {
        let x = CGFloat.random(min: min, max: max)
        let y = CGFloat.random(min: min, max: max)
        
        return CGVector(dx: x, dy: y)
    }
}
