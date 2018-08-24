//
//  CGFloat+Extension.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension CGFloat {
    
    /// Returns random number from the range.
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + CGFloat(arc4random_uniform(UInt32(max - min + 1)))
    }
}
