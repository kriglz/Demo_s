//
//  Plane.swift
//  Demo-SCNNodeAnimation
//
//  Created by Kristina Gelzinyte on 6/8/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {

    init(with position: SCNVector3) {
        super.init()
        
        let width = 1
        let height = 1
        
        self.geometry = SCNPlane(width: CGFloat(width), height: CGFloat(height))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1, alpha: 0.7)
        material.isDoubleSided = true
        
        self.geometry?.materials = [material]
                
        self.position = position
        self.position.y -= 1.01
        
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: self, options: nil))        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
