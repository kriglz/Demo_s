//
//  CGVector+Extension.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension CGVector {
    
    /// Returns angle in radians.
    var angleToNormal: CGFloat {
        let angle = atan2(dy, dx) //(dy / dx)
        return CGFloat(angle)
    }
}
