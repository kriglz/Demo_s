//
//  GameScene.swift
//  Demo-CAGradient-on-SKTexture
//
//  Created by Kristina Gelzinyte on 9/13/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        setupBackgroundNode()
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.zPosition = 1
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.zPosition = 10
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
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
    
    private func setupBackgroundNode() {
        let gradient = setupGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: self.size)
        
        let texture = SKTexture(layer: gradient, size: self.size)
        
        let node = SKSpriteNode(texture: texture, size: self.size)
        node.zPosition = 0
        self.addChild(node)
    }
    
    private func setupGradientLayer() -> CALayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(r: 17, g: 40, b: 68).cgColor,
            UIColor(r: 37, g: 72, b: 106).cgColor,
            UIColor(r: 70, g: 105, b: 136).cgColor
        ]
        gradient.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.6),
            NSNumber(value: 1)
        ]
        return gradient
    }
}

extension SKTexture {
    
    convenience init(layer: CALayer, size: CGSize) {
        let image = UIImage.image(with: layer, size: size)
        self.init(image: image)
    }
}

extension UIImage {
    
    class func image(with layer: CALayer, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            return layer.render(in: context.cgContext)
        }
        
        return image
    }
}

extension UIColor {
    
    /// Initialize a UIColor using RGB values between 0 and 255.
    convenience init(r: Int, g: Int, b: Int, alpha: Double = 1) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
}
