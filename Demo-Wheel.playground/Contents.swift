//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var square: SKNode!
    private var attachedSquare: SKNode!
    
    let squareCategoryBitMask: UInt32 = 0x1 << 2
    let attachedSquareCategoryBitMask: UInt32 = 0x1 << 5

    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        square = childNode(withName: "Square")
        attachedSquare = childNode(withName: "AttachedSquare")
        
        square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)
        square.physicsBody?.isDynamic = false
        
        attachedSquare.physicsBody = SKPhysicsBody(rectangleOf: attachedSquare.frame.size)
        
        square.physicsBody?.categoryBitMask = squareCategoryBitMask
        square.physicsBody?.contactTestBitMask = squareCategoryBitMask
        square.physicsBody?.collisionBitMask = attachedSquareCategoryBitMask
        
        attachedSquare.physicsBody?.categoryBitMask = squareCategoryBitMask
        attachedSquare.physicsBody?.contactTestBitMask = squareCategoryBitMask
        attachedSquare.physicsBody?.collisionBitMask = squareCategoryBitMask
        

        var joint = SKPhysicsJointPin.joint(withBodyA: square.physicsBody!,
                                            bodyB: attachedSquare.physicsBody!,
                                            anchor: CGPoint(x: square.frame.maxX,
                                                            y: square.frame.maxY))
        
        physicsWorld.add(joint)
        
        square.run(.repeatForever(.rotate(byAngle: CGFloat(Double.pi), duration: 10)))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    scene.scaleMode = .aspectFill
    sceneView.showsPhysics = true
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
