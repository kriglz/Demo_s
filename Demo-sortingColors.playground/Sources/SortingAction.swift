public struct SortingAction {
    
    let index: Int
    let start: Int
    let end: Int
    
    init(_ index: Int, start: Int, end: Int) {
        self.index = index
        self.start = start
        self.end = end
    }
}
