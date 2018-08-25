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
    
//    private lazy var gameSceneWorldFrame = CGRect(origin: CGPoint(x: -view!.frame.size.width, y: -view!.frame.size.height),
//                                                  size: CGSize(width: 3 * view!.frame.size.width, height: 3 * view!.frame.size.height))
    
    private lazy var gameSceneWorldFrame = CGRect(origin: CGPoint(x: 10, y: 10),
                                                  size: CGSize(width: view!.frame.size.width - 20, height: view!.frame.size.height - 20))
    
    private lazy var boidNode = BoidNode(constrainedIn: gameSceneWorldFrame)
    private let obstacleNode = ObstacleNode()
    
    private var allBoids = [BoidNode]()
    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.addChild(boidNode)
        boidNode.position = CGPoint(x: 50, y: 50)
        allBoids.append(boidNode)
        
        
        let test = SKShapeNode.init(rect: gameSceneWorldFrame)
        test.strokeColor = .white
        self.addChild(test)
        
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
        
        guard let newBoidNode = boidNode.copy() as? BoidNode else { return }
        newBoidNode.updateConfinementFrame(frame: gameSceneWorldFrame)
        newBoidNode.position = position
        newBoidNode.fillColor = SKColor.green
        self.addChild(newBoidNode)
        allBoids.append(newBoidNode)
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
    
    func updateBoidSpeednCoeficient(to value: CGFloat) {
        allBoids.forEach { $0.speedCoeficient = value }
    }
    
    func updateBoidSeparationCoeficient(to value: CGFloat) {
        allBoids.forEach { $0.separationCoeficient = value }
    }
    
    func updateBoidAlignmentCoeficient(to value: CGFloat) {
        allBoids.forEach { $0.alignmentCoeficient = value }
    }
    
    func updateBoidCohesionCoeficient(to value: CGFloat) {
        allBoids.forEach { $0.cohesionCoeficient = value }
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

