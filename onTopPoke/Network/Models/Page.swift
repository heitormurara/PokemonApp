import Foundation

struct Page {
    let limit: Int
    let offset: Int
    
    init(from urlString: String) throws {
        let pattern = #"offset=(\d+)&limit=(\d+)"#
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(urlString.startIndex..., in: urlString)
            
            guard let match = regex.firstMatch(in: urlString, range: range) else {
                throw PaginationError.noExactMatchesToRegex
            }
            
            guard let offsetRange = Range(match.range(at: 1), in: urlString),
                  let offset = Int(urlString[offsetRange]) else {
                throw PaginationError.invalidOffset
            }
            
            guard let limitRange = Range(match.range(at: 2), in: urlString),
                  let limit = Int(urlString[limitRange]) else {
                throw PaginationError.invalidLimit
            }
            
            self.offset = offset
            self.limit = limit
        } catch let error {
            throw error
        }
    }
    
    init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
}

enum PaginationError: Error {
    case invalidLimit
    case invalidOffset
    case noExactMatchesToRegex
}
