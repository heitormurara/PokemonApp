struct PaginatedResult<T: Decodable>: Decodable {
    let count: Int
    let results: [T]
}
