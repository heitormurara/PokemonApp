protocol PaginationManaging {
    var nextPage: Page? { get set }
}

struct PaginationManager: PaginationManaging {
    var nextPage: Page?
}
