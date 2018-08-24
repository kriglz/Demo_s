//
//  Array+Extensions.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit


extension Array where Element: Numeric {
    
    /// Returns the total sum of all elements in the array.
    var total: Element { return reduce(0, +) }
}

extension Array where Element: FloatingPoint {
    
    /// Returns the average of all elements in the array.
    var elementAverage: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

extension Array {
    
    /// Returns the average of all elements in the array of `CGVector`.
    var average: CGVector {
        if let vectors = self as? [CGVector] {
            
            var xArray = [CGFloat]()
            var yArray = [CGFloat]()
            
            for vector in vectors {
                xArray.append(vector.dx)
                yArray.append(vector.dy)
            }
            
            let averageX = xArray.elementAverage
            let averageY = yArray.elementAverage
            return CGVector(dx: averageX, dy: averageY)
        }
        
        return CGVector.zero
    }
}
