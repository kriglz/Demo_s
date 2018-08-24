//
//  Array+Extensions.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension Array {
    
    /// Returns the average of all elements in the array of `CGVector`.
    var averageForCGVectors: CGVector {
        let total = reduce(CGVector.zero) { (result, element) -> CGVector in
            guard let element = element as? CGVector else { return .zero }
            return CGVector(dx: result.dx + element.dx, dy: result.dy + element.dy)
        }
        
        return total.divide(by: CGFloat(count))
    }
}
