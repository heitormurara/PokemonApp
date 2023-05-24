struct Paginated<T: Decodable>: Decodable {
    let nextPage: Page?
    let array: [T]
    
    enum CodingKeys: String, CodingKey {
        case nextPage = "next"
        case array = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Paginated<T>.CodingKeys> = try decoder.container(keyedBy: Paginated<T>.CodingKeys.self)
        array = try container.decode([T].self, forKey: Paginated<T>.CodingKeys.array)
        
        if let nextString = try? container.decode(String.self, forKey: Paginated<T>.CodingKeys.nextPage) {
            nextPage = try Page(from: nextString)
        } else {
            nextPage = nil
        }
    }
    
    init(nextPage: Page?, array: [T]) {
        self.nextPage = nextPage
        self.array = array
    }
}
