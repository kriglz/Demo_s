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
    
    private var boidNode = BoidNode()
    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        boidNode = BoidNode()
        self.addChild(boidNode)
        boidNode.position = CGPoint(x: 50, y: 50)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Event control
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    private func touchDown(atPoint pos : CGPoint) {
        if let newBoidNode = boidNode.copy() as? BoidNode {
            newBoidNode.position = pos
            newBoidNode.fillColor = SKColor.green
            self.addChild(newBoidNode)
        }
    }
    
    // MARK: - Node setup

}
