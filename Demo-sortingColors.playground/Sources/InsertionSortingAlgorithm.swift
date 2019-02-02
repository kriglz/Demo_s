import Foundation

public class InsertionSortingAlgorithm {
   
    static func sort(_ array: [Int]) -> (sortedArray: [Int], sortingActions: [SortingAction]) {
        var actionIndex = 0
        var sortingArray = array
        var sortingActions = [SortingAction]()
        
        for index in 1..<sortingArray.count {
            var previousIndex = index - 1
            
            while (previousIndex >= 0 && compare(numberA: sortingArray[previousIndex], numberB: sortingArray[previousIndex + 1]) > 0) {
                sortingArray.swapAt(previousIndex, previousIndex + 1)
                
                let sortingAction = SortingAction(actionIndex, start: previousIndex, end: previousIndex + 1)
                sortingActions.append(sortingAction)
                
                previousIndex -= 1
                actionIndex += 1
            }
        }

        return (sortingArray, sortingActions)
    }
    
    static func compare(numberA: Int, numberB: Int) -> Int {
        if numberA > numberB {
            return 1
        }
        
        return 0
    }
}
