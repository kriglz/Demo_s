//
//  SCNVector3+Extensions.swift
//  Demo-HitTest
//
//  Created by Kristina Gelzinyte on 11/16/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import Cocoa
import SceneKit

extension SCNVector3 {
    
    /**
     * Returns the length (magnitude) of the vector described by the SCNVector3
     */
    var length: CGFloat {
        return sqrt(x * x + y * y + z * z)
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    var normalized: SCNVector3 {
        return self.divide(by: length)
    }
    
    /**
     * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
     */
    func divide(by scalar: CGFloat) -> SCNVector3 {
        return SCNVector3Make(self.x / scalar, self.y / scalar, self.z / scalar)
    }
}

