protocol PaginationManaging {
    var nextPage: Page? { get set }
    var isLoading: Bool { get set }
}

struct PaginationManager: PaginationManaging {
    var nextPage: Page?
    var isLoading: Bool
}
