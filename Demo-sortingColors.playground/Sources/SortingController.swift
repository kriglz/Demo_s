import Foundation

public class SortingController {
    
    private(set) var unsortedArray = [Int]()
    private(set) var sortedArray = [Int]()
    private(set) var sortingActions = [SortingAction]()

    public init(sortingMatrixSize: MatrixSize) {
        unsortedArray = generateUnsortedArray(of: sortingMatrixSize.rows)
        
        let sortingResult = InsertionSortingAlgorithm.sort(unsortedArray)

        sortedArray = sortingResult.sortedArray
        sortingActions = sortingResult.sortingActions
    }
    
    private func generateUnsortedArray(of size: Int) -> [Int] {
        return Array(0...size).shuffled()
    }
}

public struct MatrixSize {
    
    let columns: Int
    let rows: Int
}
