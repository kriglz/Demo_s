import Foundation

public class InsertionSortingAlgorithm {
    
    weak var delegate: InsertionSortingAlgorithmDelegate?
    private var sortingArray: [Int] = []
    
    init(for array: [Int]) {
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

