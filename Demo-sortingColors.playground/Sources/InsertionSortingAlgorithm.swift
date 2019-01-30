import Foundation

public class InsertionSortingAlgorithm {
    
    private var sortingArray = [Int]()
    private(set) var sortingActions = [SortingAction]()
    
    init(for array: [Int]) {
        self.sortingArray = array
    }
    
    func sort() -> [Int] {
        insertion()
        return sortingArray
    }
    
    private func insertion() {
        var actionIndex = 0
        
        for index in 1..<sortingArray.count {
            var previousIndex = index - 1
            
            while (previousIndex >= 0 && compare(numberA: sortingArray[previousIndex], numberB: sortingArray[previousIndex + 1]) > 0) {
                sortingArray.swapAt(previousIndex, previousIndex + 1)
                sortingActions.append(SortingAction(actionIndex, start: previousIndex, end: previousIndex + 1))
                
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
