import UIKit

public class GraphView: UIView {

    let width: CGFloat = 10.0
    let arraySize = 10

    public func performSorting() {

        let sortingController = SortingController(element: arraySize)
        setupGraph(for: sortingController.unsortedArray)
        performSortingAnimation(sortingController.sortingActions)
    }
    
    private func setupGraph(for unsortedArray: [Int]) {
        for (index, element) in unsortedArray.enumerated() {
            let box = ActionLayer()
            box.frame = CGRect(x: 30.0, y: 30.0, width: width, height: width)
            box.position.x += CGFloat(index) * width
            box.backgroundColor = UIColor(red: CGFloat(element) / CGFloat(arraySize), green: 0.0, blue: 1.0, alpha: 1.0).cgColor
            box.name = "\(index)"
            self.layer.addSublayer(box)
        }
    }
    
    func performSortingAnimation(_ actions: [SortingAction]) {
        actions.forEach {
            swapElements($0.start, $0.end, actionIndex: $0.index)
        }
    }
    
    func swapElements(_ i: Int, _ j: Int, actionIndex: Int) {
        guard let iElement = subview(name: "\(i)"), let jElement = subview(name: "\(j)") else {
            return
        }
        
        let deltaIndex = i.distance(to: j)
        let iTranslation = width * CGFloat(deltaIndex)
        let jTranslation = -width * CGFloat(deltaIndex)
        
        iElement.name = "\(j)"
        jElement.name = "\(i)"
        
        iElement.moveAction(by: iTranslation, actionIndex: actionIndex)
        jElement.moveAction(by: jTranslation, actionIndex: actionIndex)
    }
    
    func subview(name: String) -> ActionLayer? {
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
