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
    
    private var label = SKLabelNode(text: "HelloLabel")
    private var boidNode = BoidNode()
    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        self.addChild(label)

        label.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        label.fontSize = 30
        label.alpha = 0.0
        label.run(SKAction.fadeIn(withDuration: 2.0))
        
        boidNode = BoidNode()
        self.addChild(boidNode)
        boidNode.position = CGPoint(x: 50, y: 50)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Node setup

}
