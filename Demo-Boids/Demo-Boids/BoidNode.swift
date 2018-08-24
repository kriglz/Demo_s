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

    private let timeCounterConstant = 60

    // MARK: - Properties
    
    var neightbourBoidNodes = [BoidNode]()
    
    private lazy var directionRandomnessTimeCounter = timeCounterConstant + 1
    
    private(set) var direction = CGVector.zero
    
    private var recentDirections = [CGVector]()
    private var confinementFrame = CGRect.zero
    
    private var canUpdateBoidsDirection = true

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
    
    private var isBoidNodeInConfinementFrame: Bool {
        return confinementFrame.contains(position)
    }
    
    private var averageNeighbourhoodBoidPosition: CGVector {
        var neightbourBoidNodePositions = [direction]
        for neighbour in neightbourBoidNodes {
            neightbourBoidNodePositions.append(neighbour.direction)
        }
        return neightbourBoidNodePositions.averageForCGVectors
    }
    
    private var averageDirectionToGo: CGVector {
        if canUpdateBoidsDirection {
            recentDirections.append(direction)
            recentDirections = Array(recentDirections.suffix(30))
        }
        
        return recentDirections.averageForCGVectors
    }
    
    // MARK: - Initialization
    
    convenience init(constrainedIn frame: CGRect) {
        self.init()
        
        confinementFrame = frame
    }
    
    override init() {
        super.init()
        
        name = BoidNode.uniqueName
        path = boidPath
        fillColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Boid confinement
    
    func updateConfinementFrame(frame: CGRect) {
        confinementFrame = frame
    }
    
    // MARK: - Boid movement
    
    func move() {
        updateDirectionRandomnessIfNeeded()
        
        if canUpdateBoidsDirection, hasNeighbourBoidNodes {
            direction = averageNeighbourhoodBoidPosition
        }
        
        updatePositionAndRotation()
    }
    
    private func updateDirectionRandomnessIfNeeded() {
        directionRandomnessTimeCounter += 1
        
        if directionRandomnessTimeCounter > timeCounterConstant {
            let x = CGFloat.random(min: -10, max: 10)
            let y = CGFloat.random(min: -10, max: 10)
            
            direction = CGVector(dx: x, dy: y)
            directionRandomnessTimeCounter = 0
        }
    }

    private func updatePositionAndRotation() {
        let directionToGo = averageDirectionToGo
        
        zRotation = directionToGo.angleToNormal
        
        position.x += directionToGo.dx /// 10
        position.y += directionToGo.dy /// 10
        
        if canUpdateBoidsDirection, !isBoidNodeInConfinementFrame {
            returnBoidToConfinementFrame()
            
            canUpdateBoidsDirection = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.canUpdateBoidsDirection = true
            }
        }
    }
    
    private func returnBoidToConfinementFrame() {
        if position.x < confinementFrame.origin.x || position.x > confinementFrame.origin.x + confinementFrame.size.width {
            let flipTransformation = CGAffineTransform(scaleX: -1, y: 1).concatenating(CGAffineTransform(translationX: confinementFrame.size.width, y: 0))
            position = position.applying(flipTransformation)
        }
        
        if position.y < confinementFrame.origin.y || position.y > confinementFrame.origin.y + confinementFrame.size.height {
            let flipTransformation = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform(translationX: 0, y: confinementFrame.size.height))
            position = position.applying(flipTransformation)
        }
    }
}
