import UIKit

public class GraphView: UIView {

    private let width: CGFloat = 10.0
    private var elementsCount = 0

    public func performSorting(elements count: Int) {
        elementsCount = count
        
        let sortingController = SortingController(element: count)
        setupGraph(for: sortingController.unsortedArray)
        performSortingAnimation(sortingController.sortingActions)
    }
    
    private func setupGraph(for unsortedArray: [Int]) {
        for (index, element) in unsortedArray.enumerated() {
            let box = ActionLayer()
            box.frame = CGRect(x: 0, y: 0, width: width, height: width)
            box.position.y += CGFloat(index) * width
            box.backgroundColor = gradientColor(for: CGFloat(element) / CGFloat(elementsCount)).cgColor
            box.name = "\(index)"
            self.layer.addSublayer(box)
        }
    }
    
    private func gradientColor(for index: CGFloat) -> UIColor {
        let color1 = Color(r: 40, g: 240, b: 140)
        let color2 = Color(r: 18, g: 26, b: 218)
        
        return Color.gradientColor(color1, color2, percentage: index)
    }
    
    private func performSortingAnimation(_ actions: [SortingAction]) {
        actions.forEach {
            swapElements($0.start, $0.end, actionIndex: $0.index)
        }
    }
    
    private func swapElements(_ i: Int, _ j: Int, actionIndex: Int) {
        guard let iElement = subview(name: "\(i)"), let jElement = subview(name: "\(j)") else {
            return
        }
        
        let delta = i.distance(to: j)
        let iTranslation = width * CGFloat(delta)
        let jTranslation = -width * CGFloat(delta)
        
        iElement.name = "\(j)"
        jElement.name = "\(i)"
        
        iElement.moveAction(by: iTranslation, actionIndex: actionIndex)
        jElement.moveAction(by: jTranslation, actionIndex: actionIndex)
    }
    
    private func subview(name: String) -> ActionLayer? {
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
