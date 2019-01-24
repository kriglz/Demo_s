//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var spinnyNode : SKShapeNode!
    
    override func didMove(to view: SKView) {
        label = SKLabelNode(text: "")
        label.fontSize = 80
        sceneView.scene?.addChild(label)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        let w = (size.width + size.height) * 0.3
        spinnyNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w * 0.01, height: w / 2))
        spinnyNode.fillColor = UIColor.red
        spinnyNode.lineWidth = 0
        spinnyNode.strokeColor = .clear
        
        let seconds = Calendar.current.component(.second, from: Date())
        spinnyNode.zRotation = -CGFloat.pi * CGFloat(seconds) / 30
        spinnyNode.run(.repeatForever(.rotate(byAngle: -CGFloat.pi / 30, duration: 1)))
        sceneView.scene?.addChild(spinnyNode)
    }
    
    @objc private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        label.text = formatter.string(from: Date())
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
