//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var square: SKNode!
    private var attachedSquare: SKNode!
    private var attachedSquare2: SKNode!
    private var attachedSquare3: SKNode!
    private var attachedSquare4: SKNode!

    let squareCategoryBitMask: UInt32 = 0x1 << 2
    let attachedSquareCategoryBitMask: UInt32 = 0x1 << 5

    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        square = childNode(withName: "Square")
        
        attachedSquare = childNode(withName: "AttachedSquare")
        attachedSquare2 = childNode(withName: "AttachedSquare2")
        attachedSquare3 = childNode(withName: "AttachedSquare3")
        attachedSquare4 = childNode(withName: "AttachedSquare4")

        square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)
        square.physicsBody?.isDynamic = false
        
        attachedSquare.physicsBody = SKPhysicsBody(rectangleOf: attachedSquare.frame.size)
        attachedSquare2.physicsBody = SKPhysicsBody(rectangleOf: attachedSquare2.frame.size)
        attachedSquare3.physicsBody = SKPhysicsBody(rectangleOf: attachedSquare3.frame.size)
        attachedSquare4.physicsBody = SKPhysicsBody(rectangleOf: attachedSquare4.frame.size)

        let joint = SKPhysicsJointPin.joint(withBodyA: square.physicsBody!,
                                            bodyB: attachedSquare.physicsBody!,
                                            anchor: CGPoint(x: square.frame.maxX,
                                                            y: square.frame.maxY))
        
        let joint2 = SKPhysicsJointPin.joint(withBodyA: square.physicsBody!,
                                             bodyB: attachedSquare2.physicsBody!,
                                             anchor: CGPoint(x: square.frame.minX,
                                                             y: square.frame.maxY))
        
        let joint3 = SKPhysicsJointPin.joint(withBodyA: attachedSquare.physicsBody!,
                                             bodyB: attachedSquare3.physicsBody!,
                                             anchor: CGPoint(x: attachedSquare.frame.maxX,
                                                             y: attachedSquare.frame.maxY))
        
        let joint4 = SKPhysicsJointPin.joint(withBodyA: attachedSquare2.physicsBody!,
                                             bodyB: attachedSquare4.physicsBody!,
                                             anchor: CGPoint(x: attachedSquare2.frame.minX,
                                                             y: attachedSquare2.frame.maxY))
        physicsWorld.add(joint)
        physicsWorld.add(joint2)
        physicsWorld.add(joint3)
        physicsWorld.add(joint4)

        square.run(.repeatForever(.rotate(byAngle: CGFloat(Double.pi), duration: 3)))
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
