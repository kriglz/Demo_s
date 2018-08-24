//
//  BoidNode.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit

class BoidNode: SKShapeNode {

    // MARK: - Constants
    
    static let uniqueName = "Boid"
    static let length = 30

    private let timeCounterConstant = 120

    // MARK: - Properties
    
    var neightbourBoidNodes = [BoidNode]()
    
    private(set) var direction = CGVector.zero
    
    private lazy var timeCounter = timeCounterConstant + 1
    
    private var boidPath: CGPath {
        let triangleBezierPath = UIBezierPath()
        triangleBezierPath.move(to: CGPoint(x: -BoidNode.length, y: -10))
        triangleBezierPath.addLine(to: CGPoint(x: -BoidNode.length, y: 10))
        triangleBezierPath.addLine(to: CGPoint(x: 0, y: 0))
        triangleBezierPath.close()
        return triangleBezierPath.cgPath
    }
    
    private var hasNeighbourBoidNodes: Bool {
        return !neightbourBoidNodes.isEmpty
    }
    
    private var averageNeighbourhoodBoidPosition: CGVector {
        var neightbourBoidNodePositions = [direction]
        for neighbour in neightbourBoidNodes {
            neightbourBoidNodePositions.append(neighbour.direction)
        }
        return neightbourBoidNodePositions.average
    }
    
    // MARK: - Initialization
        
    override init() {
        super.init()
        
        name = BoidNode.uniqueName
        path = boidPath
        fillColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Movement
    
    func move() {
        updateDirectionRandomnessIfNeeded()
        
        if hasNeighbourBoidNodes {
            direction = averageNeighbourhoodBoidPosition
        }
        
        updatePositionAndRotation()
    }
    
    private func updateDirectionRandomnessIfNeeded() {
        timeCounter += 1
        
        if timeCounter > timeCounterConstant {
            let x = CGFloat.random(min: -10, max: 10) / 10
            let y = CGFloat.random(min: -10, max: 10) / 10
            
            direction = CGVector(dx: x, dy: y)
            timeCounter = 0
        }
    }

    private func updatePositionAndRotation() {
        zRotation = direction.angleToNormal
        position.x += direction.dx
        position.y += direction.dy
    }
}
