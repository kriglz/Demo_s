import UIKit

public class GraphView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let arraySize = 10
        
        let unsortedArray = generateUnsortedArray(of: arraySize)
        setupGraph(for: unsortedArray)
        
        let sortingResult = InsertionSortingAlgorithm.sort(unsortedArray)
        performSortingAnimation(sortingResult.sortiingActions)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateUnsortedArray(of size: Int) -> [Int] {
        return [15, 09, 08, 01, 04, 11, 07, 12, 13, 06, 05, 03, 16, 02, 10, 14]
    }
    
    func setupGraph(for unsortedArray: [Int]) {
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
    
    func performSortingAnimation(_ actions: [SortingAction]) {
        for action in actions {
            swapElements(action.start, action.end, actionIndex: action.index)
        }
    }
    
    func swapElements(_ i: Int, _ j: Int, actionIndex: Int) {
        guard let iLayer = (self.layer.sublayers?.first { $0.name == "\(i)" } as? ActionLayer),
            let jLayer = (self.layer.sublayers?.first { $0.name == "\(j)" } as? ActionLayer) else { return }
        
        let deltaIndex = i.distance(to: j)
        let iLayerTranslationLength = CGFloat(ActionLayer.width * 1.2) * CGFloat(deltaIndex)
        let jLayerTranslationLength = -CGFloat(ActionLayer.width * 1.2) * CGFloat(deltaIndex)
        
        iLayer.name = "\(j)"
        jLayer.name = "\(i)"
        
        iLayer.addMoveByAction(translationLength: iLayerTranslationLength, actionIndex: actionIndex)
        jLayer.addMoveByAction(translationLength: jLayerTranslationLength, actionIndex: actionIndex)
    }
}
