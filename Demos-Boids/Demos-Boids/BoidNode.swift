//
//  BoidNode.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BoidNode: SKShapeNode {

    private var boidPath: CGPath {
        let triangleBezierPath = UIBezierPath()
        triangleBezierPath.move(to: CGPoint.zero)
        triangleBezierPath.addLine(to: CGPoint(x: 20, y: 0))
        triangleBezierPath.addLine(to: CGPoint(x: 20, y: 0))
        triangleBezierPath.addLine(to: CGPoint(x: 10, y: 30))
        triangleBezierPath.close()
        return triangleBezierPath.cgPath
    }
    
    override init() {
        super.init()
        
        path = boidPath
        fillColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
