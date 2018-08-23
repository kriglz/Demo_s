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
    
    private var label = SKLabelNode(text: "HelloLabel")
    private var spinnyNode = SKShapeNode()
    
    override func didMove(to view: SKView) {
        
        self.addChild(label)
        self.addChild(spinnyNode)

        label.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        label.fontSize = 30
        
        // Get label node from scene and store it for use later
        label.alpha = 0.0
        label.run(SKAction.fadeIn(withDuration: 2.0))
        
        // Create shape node to use during mouse interaction
        let w = (view.frame.size.width + view.frame.size.height) * 0.05
        spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)
        
        spinnyNode.lineWidth = 2.5
        
        spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                          SKAction.fadeOut(withDuration: 0.5),
                                          SKAction.removeFromParent()]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode.copy() as? SKShapeNode {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.removeAllActions()
        label.run(SKAction.fadeOut(withDuration: 1.0))
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
