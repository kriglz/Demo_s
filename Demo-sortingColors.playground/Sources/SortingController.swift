import Foundation

public class SortingController {
    
    private(set) var unsortedArray = [Int]()
    private(set) var sortedArray = [Int]()
    private(set) var sortingActions = [SortingAction]()

    public init(element count: Int) {
        unsortedArray = generateUnsortedArray(of: count)
        
        let sortingResult = InsertionSortingAlgorithm.sort(unsortedArray)

        sortedArray = sortingResult.sortedArray
        sortingActions = sortingResult.sortingActions
    }
    
    private func generateUnsortedArray(of size: Int) -> [Int] {
        return [15, 09, 08, 01, 04, 11, 07, 12, 13, 06, 05, 03, 16, 02, 10, 14]
    }
    
    
    
}
