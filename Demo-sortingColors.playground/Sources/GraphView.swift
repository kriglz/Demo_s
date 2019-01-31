import UIKit

public class GraphView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let arraySize = 10
        
        let unsortedArray = generateUnsortedArray(of: arraySize)
        setupGraph(for: unsortedArray)
        
        let sortingResult = InsertionSortingAlgorithm.sort(unsortedArray)
        let sortedArray = sortingResult.sortedArray
        
        print(unsortedArray)
        print(sortedArray)
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateUnsortedArray(of size: Int) -> [Int] {
        return [15, 09, 08, 01, 04, 11, 07, 12, 13, 06, 05, 03, 16, 02, 10, 14]
    }
    
    // MARK: - SpriteKit setup
    
    /// Sets up graph view with unsorted children.
    public func setupGraph(for unsortedArray: [Int]) {
        for (index, number) in unsortedArray.enumerated() {
            let rect = CGRect(x: Double(index) * ActionLayer.width * 1.2 + 30.0,
                              y: 30.0,
                              width: ActionLayer.width,
                              height: ActionLayer.heightMultiplicationConstant * Double(number))
            
            let box = ActionLayer()
            box.frame = rect
            box.backgroundColor = ActionLayer.defaultColor.cgColor
            box.name = "\(index)"
            self.layer.addSublayer(box)
        }
    }
    
    // MARK: - Animation
    
    /// Swap specific elements of the array.
    func swapElements(_ i: Int, _ j: Int, actionIndex: Int, isInActiveRange: Bool = false) {
        guard let iLayer = (self.layer.sublayers?.first { $0.name ==  "\(i)" } as? ActionLayer),
            let jLayer = (self.layer.sublayers?.first { $0.name == "\(j)" } as? ActionLayer) else { return }
        
        let deltaIndex = i.distance(to: j)
        let iLayerTranslationLength = CGFloat(ActionLayer.width * 1.2) * CGFloat(deltaIndex)
        let jLayerTranslationLength = -CGFloat(ActionLayer.width * 1.2) * CGFloat(deltaIndex)
        
        iLayer.name = "\(j)"
        jLayer.name = "\(i)"
        
        iLayer.addMoveByAction(translationLength: iLayerTranslationLength, actionIndex: actionIndex, isInActiveRange: isInActiveRange)
        jLayer.addMoveByAction(translationLength: jLayerTranslationLength, actionIndex: actionIndex, isInActiveRange: isInActiveRange)
    }
    
    /// Update elements value or/and height.
    func updateElement(_ element: Int, to value: Int, actionIndex: Int) {
        guard let layer = (self.layer.sublayers?.first { $0.name ==  "\(element)" }) as? ActionLayer else { return }
        layer.addHeightChangeAction(height: value, actionIndex: actionIndex)
    }
    
    /// Performs the sorting animation.
    func runAnimation() {
        self.layer.sublayers?.forEach { layer in
            if let actionLayer = layer as? ActionLayer {
                actionLayer.runActions()
            }
        }
    }
}
