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
    
    private let boidNode = BoidNode()
    private let obstacleNode = ObstacleNode()
    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.addChild(boidNode)
        boidNode.position = CGPoint(x: 50, y: 50)
        
        self.addChild(obstacleNode)
        obstacleNode.position = CGPoint(x: 100, y: 100)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Event control
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let flipTransform = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform.init(translationX: 0, y: view.frame.height))
        let position = gestureRecognizer.location(in: view).applying(flipTransform)
        
        guard let newBoidNode = boidNode.copy() as? BoidNode else { return }
        newBoidNode.position = position
        newBoidNode.fillColor = SKColor.green
        self.addChild(newBoidNode)
    }
    
    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let flipTransform = CGAffineTransform(scaleX: 1, y: -1).concatenating(CGAffineTransform.init(translationX: 0, y: view.frame.height))
        let position = gestureRecognizer.location(in: view).applying(flipTransform)

        guard let newObstacleNode = obstacleNode.copy() as? ObstacleNode else { return }
        newObstacleNode.position = position
        self.addChild(newObstacleNode)
    }
    
    // MARK: - Node setup

}
