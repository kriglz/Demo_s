import UIKit
import SpriteKit

public class GraphView: SKView {
    
    private var unsortedSortingArray: [Int] = []
    
    // MARK: - Initialization
    
    public convenience init(array: [Int]) {
        self.init(frame: .zero)
        self.unsortedSortingArray = array
        self.backgroundColor = .clear
    }
    
    public func sortByInsertion() {
        let insertionSortingAlgorithm = InsertionSortingAlgorithm(for: unsortedSortingArray)
        let sortedArray = insertionSortingAlgorithm.sort()
        print("Insertion Sort Algorithm sorted array \(sortedArray)")
    }
    
    // MARK: - SpriteKit setup
    
    /// Sets up graph view with unsorted children.
    public func setupGraph() {
        for (index, number) in unsortedSortingArray.enumerated() {
            
            let rect = CGRect(x: Double(index) * ActionSpriteNode.width * 1.2 + 30.0,
                              y: 30.0,
                              width: ActionSpriteNode.width,
                              height: ActionSpriteNode.heightMultiplicationConstant * Double(number))
            
            let node = ActionSpriteNode()
            node.anchorPoint.y = 0
            node.color = ActionSpriteNode.defaultColor
            node.position = rect.origin
            node.size = rect.size
            
            node.name = "\(index)"
            
            self.scene?.addChild(node)
        }
    }

    // MARK: - Animation
    
    /// Swap specific elements of the array.
    func swapElements(_ i: Int, _ j: Int, actionIndex: Int, isInActiveRange: Bool = false) {
        guard let iNode = scene?.childNode(withName: "\(i)") as? ActionSpriteNode,
            let jNode = scene?.childNode(withName: "\(j)") as? ActionSpriteNode else { return }
        
        let deltaIndex = i.distance(to: j)
        let iNodeTranslationLength = CGFloat(ActionSpriteNode.width * 1.2) * CGFloat(deltaIndex)
        let jNodeTranslationLength = -CGFloat(ActionSpriteNode.width * 1.2) * CGFloat(deltaIndex)
        
        iNode.name = "\(j)"
        jNode.name = "\(i)"
        
        iNode.addMoveByAction(translationLength: iNodeTranslationLength, actionIndex: actionIndex, isInActiveRange: isInActiveRange)
        jNode.addMoveByAction(translationLength: jNodeTranslationLength, actionIndex: actionIndex, isInActiveRange: isInActiveRange)
    }
    
    /// Color active elements of array.
    func colorElements(_ elementIndexes: [Int], actionIndex: Int) {
        self.scene?.children.forEach { child in
            if let node = child as? ActionSpriteNode {
                if let name = node.name, let nodeName = Int(name), elementIndexes.contains(nodeName) {
                    node.addColorAction(isColorized: true, actionIndex: actionIndex)
                } else {
                    node.addColorAction(isColorized: false, actionIndex: actionIndex)
                }
            }
        }
    }
    
    /// Update elements value or/and height.
    func updateElement(_ element: Int, to value: Int, actionIndex: Int) {
        guard let node = scene?.childNode(withName: "\(element)") as? ActionSpriteNode else { return }
        node.addHeightChangeAction(height: value, actionIndex: actionIndex)
    }
    
    /// Performs the sorting animation.
    func runAnimation() {
        self.scene?.children.forEach { child in
            if let node = child as? ActionSpriteNode {
                node.runActions()
            }
        }
    }
}
