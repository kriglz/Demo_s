//
//  GameScene.swift
//  Demos-Boids
//
//  Created by Kristina Gelzinyte on 8/23/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    private lazy var gameSceneWorldFrame = CGRect(origin: CGPoint(x: 300, y: 100),
                                                  size: CGSize(width: view!.frame.size.width - 600, height: view!.frame.size.height - 200))
    
    private lazy var boidNode = BoidNode(constrainedIn: gameSceneWorldFrame)
    private let obstacleNode = ObstacleNode()
    
    private var allBoids = [BoidNode]()
    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = .black
        
        self.addChild(boidNode)
        boidNode.position = CGPoint(x: 50, y: 50)
        allBoids.append(boidNode)
        
        for _ in 0...30 {
            spitNewBoid(at: CGPoint(x: CGFloat.random(min: gameSceneWorldFrame.origin.x, max: gameSceneWorldFrame.origin.x + gameSceneWorldFrame.size.width),
                                    y: CGFloat.random(min: gameSceneWorldFrame.origin.y, max: gameSceneWorldFrame.origin.y + gameSceneWorldFrame.size.height)))
        }
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateBoidAlignmentCoefficient), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(updateBoidCohesionCoefficient), userInfo: nil, repeats: true)

//        let test = SKShapeNode(rect: gameSceneWorldFrame)
//        test.strokeColor = .clear
//        self.addChild(test)
        
//        self.addChild(obstacleNode)
//        obstacleNode.position = CGPoint(x: 100, y: 100)
        
//        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
//        doubleTapGestureRecognizer.numberOfTapsRequired = 2
//        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
//        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        scanBoidsInNeighborhood()
        allBoids.forEach { $0.move() }
    }
    
    // MARK: - Event control
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let flipTransform = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform.init(translationX: 0, y: view.frame.height))
        let position = gestureRecognizer.location(in: view).applying(flipTransform)
        
        spitNewBoid(at: position)
    }
    
//    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
//        guard let view = self.view else { return }
//
//        let flipTransform = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform.init(translationX: 0, y: view.frame.height))
//        let position = gestureRecognizer.location(in: view).applying(flipTransform)
//
//        guard let newObstacleNode = obstacleNode.copy() as? ObstacleNode else { return }
//        newObstacleNode.position = position
//        self.addChild(newObstacleNode)
//    }
    
    // MARK: - Node control
    
    func spitNewBoid(at position: CGPoint) {
        guard let newBoidNode = boidNode.copy() as? BoidNode else { return }
        newBoidNode.updateConfinementFrame(frame: gameSceneWorldFrame)
        newBoidNode.position = position
        self.addChild(newBoidNode)
        allBoids.append(newBoidNode)
    }
    
    func updateBoidSpeednCoefficient(to value: CGFloat) {
        allBoids.forEach { $0.speedCoefficient = value }
    }
    
    func updateBoidSeparationCoefficient(to value: CGFloat) {
        allBoids.forEach { $0.separationCoefficient = value }
    }
    
    @objc func updateBoidAlignmentCoefficient(to value: CGFloat) {        
        if value <= 2 {
            allBoids.forEach { $0.alignmentCoefficient = value}
        } else {
            let random = CGFloat.random(min: 0, max: 0.5)

            if let boid = allBoids.first, boid.alignmentCoefficient > 1 {
                allBoids.forEach { $0.alignmentCoefficient -= random}
            } else {
                allBoids.forEach { $0.alignmentCoefficient += random}
            }
        }
    }

    @objc func updateBoidCohesionCoefficient(to value: CGFloat) {
        if value <= 2 {
            allBoids.forEach { $0.cohesionCoefficient = value }
        } else {
            let random = CGFloat.random(min: 0, max: 1)
            
            if let boid = allBoids.first, boid.cohesionCoefficient > 1 {
                allBoids.forEach { $0.cohesionCoefficient -= random}
            } else {
                allBoids.forEach { $0.cohesionCoefficient += random}
            }
        }
    }
    
    private func scanBoidsInNeighborhood() {
        for boid in allBoids {
            let neighbourBoids = allBoids.filter { possiblyNeighbourBoid in
                guard boid != possiblyNeighbourBoid else {
                    return false
                }
                
                if boid.position.distance(to: possiblyNeighbourBoid.position) < CGFloat(BoidNode.length * 4) {
                    return true
                }
                
                return false
            }
            
            boid.neightbourBoidNodes = neighbourBoids
        }
    }
}

