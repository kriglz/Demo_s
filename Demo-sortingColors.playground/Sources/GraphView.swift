import UIKit

public class GraphView: UIView {

    private let pixelSize: CGFloat
    private let columns: Int
    private let rows: Int
    
    private var reverse = false
    private var actions = [[SortingAction]]()
    private var deadline = 0.0

    public init(columns: Int, rows: Int, pixelSize: CGFloat) {
        self.pixelSize = pixelSize
        self.columns = columns
        self.rows = rows
        
        super.init(frame: .zero)
        
        let size = MatrixSize(columns: columns, rows: rows)
        let sortingController = SortingController(sortingMatrixSize: size)
        
        self.deadline = Double(sortingController.sortingActions.count) * ActionLayer.actionDuration
        self.actions = sortingController.sortingActions
        
        self.setupGraph(for: sortingController.unsortedArray)
        self.performSorting()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Could not load")
    }
    
    private func setupGraph(for unsortedArray: [[Int]]) {
        var deltaOriginX: CGFloat = 0.0
        
        for columnUnsortedArray in unsortedArray {
            for (index, element) in columnUnsortedArray.enumerated() {
                let box = ActionLayer()
                box.frame = CGRect(x: deltaOriginX, y: 0.0, width: pixelSize, height: pixelSize)
                box.position.y += CGFloat(index) * pixelSize
                box.backgroundColor = gradientColor(for: CGFloat(element) / CGFloat(rows)).cgColor
                box.name = "\(index)"
                self.layer.addSublayer(box)
            }
            
            deltaOriginX += pixelSize
        }
    }
    
    private func performSorting() {
        let animation = self.reverse ? actions.reversed() : actions
//        self.performSortingAnimation(animation)
        self.reverse = !self.reverse

        DispatchQueue.main.asyncAfter(deadline: .now() + self.deadline + 2.0) {
            self.performSorting()
        }
    }
    
    private func gradientColor(for index: CGFloat) -> UIColor {
        let color1 = Color(r: 255, g: 0, b: 0)
        let color2 = Color(r: 0, g: 20, b: 255)
        return Color.gradientColor(color1, color2, percentage: index)
    }
    
    private func performSortingAnimation(_ actions: [SortingAction]) {
        actions.forEach {
            let index = self.reverse ? actions.count + 1 - $0.index : $0.index
            swapElements($0.start, $0.end, actionIndex: index)
        }
    }
    
    private func swapElements(_ i: Int, _ j: Int, actionIndex: Int) {
        guard let iElement = subview(name: "\(i)"), let jElement = subview(name: "\(j)") else {
            return
        }
        
        let delta = i.distance(to: j)
        let iTranslation = pixelSize * CGFloat(delta)
        let jTranslation = -pixelSize * CGFloat(delta)
        
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
