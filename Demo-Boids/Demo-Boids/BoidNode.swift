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
    static let length = 20

    private let circle = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
    
    private let defaultColor = UIColor(white: 1, alpha: 0.2)
    
    // MARK: - Properties
    
    var neightbourBoidNodes = [BoidNode]() {
        didSet {
            guard neightbourBoidNodes.count != oldValue.count, neightbourBoidNodes.count > 0 else { return }
            
            let boidsCount = CGFloat(neightbourBoidNodes.count)
            
            if boidsCount > 10 {
                fillColor = UIColor(white: 1, alpha: 0.7)
                return
            }
            
            if boidsCount > 6 {
                fillColor = UIColor(white: 1, alpha: 0.55)
                return
            }
            
            if boidsCount > 3 {
                fillColor = UIColor(white: 1, alpha: 0.4)
                return
            }
            
            fillColor = defaultColor
        }
    }
    
    var speedCoefficient = CGFloat(0.6)
    var separationCoefficient = CGFloat(0.35)
    var alignmentCoefficient = CGFloat(1.0)
    var cohesionCoefficient = CGFloat(1.0)
    
    private(set) var direction = CGVector.random(min: -10, max: 10)
    private var recentDirections = [CGVector]()

    private var confinementFrame = CGRect.zero
    
    private var canUpdateBoidsPosition = true

    private var boidPath: CGPath {
        let triangleBezierPath = UIBezierPath()
//        triangleBezierPath.move(to: CGPoint(x: -BoidNode.length, y: -10))
//        triangleBezierPath.addLine(to: CGPoint(x: -BoidNode.length, y: 10))
//        triangleBezierPath.addLine(to: CGPoint(x: 0, y: 0))
        
        triangleBezierPath.move(to: CGPoint(x: -BoidNode.length, y: -10))
        triangleBezierPath.addLine(to: CGPoint(x: -BoidNode.length, y: 10))
        triangleBezierPath.addLine(to: CGPoint(x: 0, y: 10))
        triangleBezierPath.addLine(to: CGPoint(x: 0, y: -10))

        triangleBezierPath.close()
        return triangleBezierPath.cgPath
    }
    
    private var hasNeighbourBoids: Bool {
        return !neightbourBoidNodes.isEmpty
    }
    
    private var isBoidNodeInConfinementFrame: Bool {
        return confinementFrame.contains(position)
    }

    private var alignmentVector: CGVector {
        return averageNeighbourhoodBoidDirection
    }
    
    private var cohesionVector: CGVector {
        return position.vector(to: averageNeighbourhoodBoidPosition)
    }
    
    private var separationVector: CGVector {
        return averageNeighbourhoodBoidDistance.multiply(by: -1.0)
    }
    
    private var averageNeighbourhoodBoidDirection: CGVector {
        var neightbourBoidNodeDirection = [direction]
        for neighbour in neightbourBoidNodes {
            neightbourBoidNodeDirection.append(neighbour.direction)
        }
        return neightbourBoidNodeDirection.averageForCGVectors
    }
    
    private var averageNeighbourhoodBoidPosition: CGPoint {
        var neightbourBoidNodePosition = [position]
        for neighbour in neightbourBoidNodes {
            neightbourBoidNodePosition.append(neighbour.position)
        }
        return neightbourBoidNodePosition.averageForCGPoint
    }
    
    private var averageNeighbourhoodBoidDistance: CGVector {
        var neightbourBoidNodeDistance = [CGVector]()
        for neighbour in neightbourBoidNodes {
            neightbourBoidNodeDistance.append(position.vector(to: neighbour.position))
        }
        
        let averageDistance = neightbourBoidNodeDistance.averageForCGVectors
        let distance = averageDistance.length > CGFloat(BoidNode.length) / 2 ? averageDistance : CGVector(dx: BoidNode.length / 2, dy: BoidNode.length / 2)
        
        return distance
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
        fillColor = defaultColor
        strokeColor = .clear
        
        let radom = Double(CGFloat.random(min: 0.2, max: 1.2))
        Timer.scheduledTimer(timeInterval: radom, target: self, selector: #selector(updateDirectionRandomness), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(boidParticles), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Boid particle setup

    @objc func boidParticles() {
        if let copyCircle = circle.copy() as? SKShapeNode {
            copyCircle.fillColor = fillColor
            copyCircle.strokeColor = .clear
            copyCircle.position = position
            
            self.parent?.addChild(copyCircle)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            
            copyCircle.run(fadeOut) {
                copyCircle.removeFromParent()
            }
        }
    }
    
    // MARK: - Boid confinement
    
    func updateConfinementFrame(frame: CGRect) {
        confinementFrame = frame
    }
    
    // MARK: - Boid movement
    
    @objc private func updateDirectionRandomness() {
        direction = CGVector.random(min: -10, max: 10)
    }

    func move() {
        if canUpdateBoidsPosition {
            if hasNeighbourBoids {
                let aligment = alignmentVector.normalized.multiply(by: alignmentCoefficient)
                let cohesion = cohesionVector.normalized.multiply(by: cohesionCoefficient)
                let separation = separationVector.normalized.multiply(by: separationCoefficient)
                
                direction = aligment.add(cohesion).add(separation).multiply(by: 10)
            }

            recentDirections.append(direction)
            recentDirections = Array(recentDirections.suffix(20))
        }
        
        updatePosition()
        updateRotation()
    }

    private func updatePosition() {
        let averageDirection = recentDirections.averageForCGVectors.multiply(by: speedCoefficient)
        
        position.x += averageDirection.dx
        position.y += averageDirection.dy
        
        if canUpdateBoidsPosition, !isBoidNodeInConfinementFrame {
            returnBoidToConfinementFrame()
            
            canUpdateBoidsPosition = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.canUpdateBoidsPosition = true
            }
        }        
    }

    private func updateRotation() {
        let averageDirection = recentDirections.averageForCGVectors
        zRotation = averageDirection.normalized.angleToNormal * CGFloat.random(min: 0.97, max: 1.03)
    }
    
    private func returnBoidToConfinementFrame() {
        if position.x < confinementFrame.origin.x {
            position.x = confinementFrame.origin.x + confinementFrame.size.width
        }
        
        if position.x > confinementFrame.origin.x + confinementFrame.size.width {
            position.x = confinementFrame.origin.x
        }
        
        if position.y < confinementFrame.origin.y {
            position.y = confinementFrame.origin.y + confinementFrame.size.height
        }
        
        if position.y > confinementFrame.origin.y + confinementFrame.size.height {
            position.y = confinementFrame.origin.y
        }
    }
}
