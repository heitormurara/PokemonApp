struct PaginatedResult<T: Decodable>: Decodable {
    let count: Int
    let next: Page?
    let previous: Page?
    let results: [T]
    
    enum CodingKeys: CodingKey {
        case count
        case next
        case previous
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<PaginatedResult<T>.CodingKeys> = try decoder.container(keyedBy: PaginatedResult<T>.CodingKeys.self)
        count = try container.decode(Int.self, forKey: PaginatedResult<T>.CodingKeys.count)
        results = try container.decode([T].self, forKey: PaginatedResult<T>.CodingKeys.results)
        
        if let nextString = try? container.decode(String.self, forKey: PaginatedResult<T>.CodingKeys.next) {
            next = try Page(from: nextString)
        } else {
            next = nil
        }
        
        if let previousString = try? container.decode(String.self, forKey: PaginatedResult<T>.CodingKeys.previous) {
            previous = try Page(from: previousString)
        } else {
            previous = nil
        }
    }
}
