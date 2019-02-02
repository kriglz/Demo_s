import UIKit

public class GraphView: UIView {

    let width = 10.0
    
    public func performSorting() {
        let arraySize = 10

        let unsortedArray = generateUnsortedArray(of: arraySize)
        setupGraph(for: unsortedArray)

        let sortingResult = InsertionSortingAlgorithm.sort(unsortedArray)
        performSortingAnimation(sortingResult.sortingActions)
    }
        
    func generateUnsortedArray(of size: Int) -> [Int] {
        return [15, 09, 08, 01, 04, 11, 07, 12, 13, 06, 05, 03, 16, 02, 10, 14]
    }
    
    func setupGraph(for unsortedArray: [Int]) {
        for (index, number) in unsortedArray.enumerated() {
            let rect = CGRect(x: Double(index) * width * 1.2 + 30.0,
                              y: 30.0,
                              width: width,
                              height: width * Double(number))
            
            let box = ActionLayer()
            box.frame = rect
            box.backgroundColor = UIColor.white.cgColor
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
        guard let iLayer = subview(of: "\(i)"), let jLayer = subview(of: "\(j)") else {
            return
        }
        
        let deltaIndex = i.distance(to: j)
        let iTranslation = CGFloat(width * 1.2) * CGFloat(deltaIndex)
        let jTranslation = -CGFloat(width * 1.2) * CGFloat(deltaIndex)
        
        iLayer.name = "\(j)"
        jLayer.name = "\(i)"
        
        iLayer.moveAction(by: iTranslation, actionIndex: actionIndex)
        jLayer.moveAction(by: jTranslation, actionIndex: actionIndex)
    }
    
    func subview(of name: String) -> ActionLayer? {
        guard let sublayers = self.layer.sublayers else {
            return nil
        }
        
        for layer in sublayers {
            if let actionLayer = layer as? ActionLayer, actionLayer.name == name {
                return actionLayer
            }
        }
        
        return nil
    }
}
