//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var secondNode : SKShapeNode!
    private var minuteNode : SKShapeNode!
    private var hourNode : SKShapeNode!

    var second: CGFloat {
        return CGFloat(Calendar.current.component(.second, from: Date()))
    }
    
    var minute: CGFloat {
        return CGFloat(Calendar.current.component(.minute, from: Date()))
    }
    
    var hour: CGFloat {
        return CGFloat(Calendar.current.component(.hour, from: Date()))
    }
    
    var secondAngle: CGFloat {
        return -CGFloat.pi * self.second / 30
    }
    
    var minuteAngle: CGFloat {
        return -CGFloat.pi * self.minute / 30
    }
    
    var hourAngle: CGFloat {
        return -CGFloat.pi * self.hour / 6
    }
    
    override func didMove(to view: SKView) {
        label = SKLabelNode(text: "")
        label.fontSize = 80
        sceneView.scene?.addChild(label)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        let w = (size.width + size.height) * 0.3
        secondNode = SKShapeNode(rect: CGRect(x: 0, y: -20, width: w * 0.01, height: 20 + w / 2))
        secondNode.fillColor = .red
        secondNode.lineWidth = 0
        secondNode.strokeColor = .clear
        secondNode.zRotation = self.secondAngle
        sceneView.scene?.addChild(secondNode)
        secondNode.run(.repeatForever(.rotate(byAngle: -CGFloat.pi / 30, duration: 1)))

        minuteNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w * 0.01, height: w / 2))
        minuteNode.fillColor = .white
        minuteNode.lineWidth = 0
        minuteNode.strokeColor = .clear
        minuteNode.zRotation = self.minuteAngle
        sceneView.scene?.addChild(minuteNode)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMinutes), userInfo: nil, repeats: true)
        
        hourNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w * 0.01, height: w / 3))
        hourNode.fillColor = .white
        hourNode.lineWidth = 0
        hourNode.strokeColor = .clear
        hourNode.zRotation = self.hourAngle
        sceneView.scene?.addChild(hourNode)
        Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(updateHours), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        label.text = formatter.string(from: Date())
    }
    
    @objc private func updateMinutes() {
        minuteNode.zRotation = self.minuteAngle
    }
    
    @objc private func updateHours() {
        hourNode.zRotation = self.hourAngle
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
