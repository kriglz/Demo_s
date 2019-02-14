import UIKit

public class GraphView: UIView {
    
    private let pixelSize: CGFloat
    private let columns: Int
    private let rows: Int
    
    private var reverse = false
    private var actions = [[SortingAction]]()
    
    private var duration: Double {
        return self.reverse ? 0.05 : 0.03
    }
    
    private var deadline: Double {
        let maximum = actions.max { i, j -> Bool in
            i.count < j.count
        }
        
        guard maximum != nil else {
            return 0
        }
       
        return Double(maximum!.count) * self.duration + 0.4
    }

    public init(columns: Int, rows: Int, pixelSize: CGFloat) {
        self.pixelSize = pixelSize
        self.columns = columns
        self.rows = rows
        
        super.init(frame: .zero)
        
        let size = MatrixSize(columns: columns, rows: rows)
        let sortingController = SortingController(sortingMatrixSize: size)
        
        self.actions = sortingController.sortingActions
        
        self.setupGraph(for: sortingController.unsortedArray)
        self.performSorting()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Could not load")
    }
    
    private func setupGraph(for unsortedArray: [[Int]]) {
        var deltaOriginX: CGFloat = 0.0
        
        for (columnIndex, columnActions) in unsortedArray.enumerated() {
            for (rowIndex, rowActions) in columnActions.enumerated() {
                let box = ActionLayer()
                box.frame = CGRect(x: deltaOriginX, y: 0.0, width: pixelSize, height: pixelSize)
                box.position.y += CGFloat(rowIndex) * pixelSize
                box.backgroundColor = gradientColor(for: CGFloat(rowActions) / CGFloat(rows)).cgColor
                box.name = "\(columnIndex)\(rowIndex)"
                self.layer.addSublayer(box)
            }
            
            deltaOriginX += pixelSize
        }
    }
    
    private func performSorting() {
        for (columnIndex, columnActions) in actions.enumerated() {
            let sortingActions = self.reverse ? columnActions.reversed() : columnActions
            let totalNumberOfAction = columnActions.count + 1
            
            sortingActions.forEach {
                let index = self.reverse ? totalNumberOfAction - $0.index : $0.index
                self.swapElements($0.start, $0.end, at: columnIndex, actionIndex: index)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.deadline) {
            self.performSorting()
        }
        
        self.reverse = !self.reverse
    }
    
    private func gradientColor(for index: CGFloat) -> UIColor {
        let color1 = Color(r: 255, g: 0, b: 0)
        let color2 = Color(r: 0, g: 20, b: 255)
        return Color.gradientColor(color1, color2, percentage: index)
    }
    
    private func swapElements(_ i: Int, _ j: Int, at column: Int, actionIndex: Int) {
        guard let iElement = self.subview(name: "\(column)\(i)"), let jElement = self.subview(name: "\(column)\(j)") else {
            return
        }
        
        iElement.name = "\(column)\(j)"
        jElement.name = "\(column)\(i)"
        
        let delta = i.distance(to: j)
        let iTranslation = pixelSize * CGFloat(delta)
        let jTranslation = -pixelSize * CGFloat(delta)
        
        iElement.moveAction(by: iTranslation, duration: self.duration, actionIndex: actionIndex)
        jElement.moveAction(by: jTranslation, duration: self.duration, actionIndex: actionIndex)
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
