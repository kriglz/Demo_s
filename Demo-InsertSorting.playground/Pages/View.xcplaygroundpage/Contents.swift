//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

class InsertionSortingAlgorithm: NSObject {
    
    weak var delegate: InsertionSortingAlgorithmDelegate?
    private var sortingArray: [Int] = []
    
    convenience init(for array: [Int]) {
        self.init()
        self.sortingArray = array
    }
    
    func sort() -> [Int] {
        insertion()
        delegate?.insertionSortingAlgorithmDidFinishSorting(self)
        return sortingArray
    }
    
    private func insertion() {
        var actionIndex = 0
        
        for index in 1..<sortingArray.count {
            var previousIndex = index - 1
            
            while (previousIndex >= 0 && compare(numberA: sortingArray[previousIndex], numberB: sortingArray[previousIndex + 1]) > 0) {
                sortingArray.swapAt(previousIndex, previousIndex + 1)
                delegate?.insertionSortingAlgorithm(self, didSwap: previousIndex, and: previousIndex + 1, actionIndex: actionIndex)
                previousIndex -= 1
                actionIndex += 1
            }
        }
    }
    
    func compare(numberA: Int, numberB: Int) -> Int {
        if numberA > numberB {
            return 1
        }
        return 0
    }
}

protocol InsertionSortingAlgorithmDelegate: class {
    
    func insertionSortingAlgorithm(_ algorithm: InsertionSortingAlgorithm, didSwap indexA: Int, and indexB: Int, actionIndex: Int)
    func insertionSortingAlgorithmDidFinishSorting(_ algorithm: InsertionSortingAlgorithm)
}

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode!
    
    override func didMove(to view: SKView) {
        // Create shape node to use during mouse interaction
        let w = (size.width + size.height) * 0.05
        
        spinnyNode = SKShapeNode(rectOf: CGSize(width: w, height: w), cornerRadius: w * 0.3)
        spinnyNode.lineWidth = 2.5
        
        let fadeAndRemove = SKAction.sequence([.wait(forDuration: 0.5),
                                               .fadeOut(withDuration: 0.5),
                                               .removeFromParent()])
        spinnyNode.run(.repeatForever(.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        spinnyNode.run(fadeAndRemove)
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
