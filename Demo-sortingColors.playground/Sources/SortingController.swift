import Foundation

public class SortingController {
    
    private(set) var unsortedArray = [[Int]]()
    private(set) var sortedArray = [[Int]]()
    private(set) var sortingActions = [[SortingAction]]()

    public init(sortingMatrixSize: MatrixSize) {
        self.unsortedArray = []
        self.sortedArray = []
        self.sortingActions = []
        
        for _ in 0...sortingMatrixSize.columns {
            let unsorted = self.generateUnsortedArray(of: sortingMatrixSize.rows)
            let sortingResult = InsertionSortingAlgorithm.sort(unsorted)
            
            self.unsortedArray.append(unsorted)
            self.sortedArray.append(sortingResult.sortedArray)
            self.sortingActions.append(sortingResult.sortingActions)
        }
    }
    
    private func generateUnsortedArray(of size: Int) -> [Int] {
        return Array(0...size).shuffled()
    }
}

public struct MatrixSize {
    
    let columns: Int
    let rows: Int
}
