import Foundation

struct SpecieDetails: Decodable {
    private let evolutionChain: URLObject
    
    var evolutionChainId: Int? {
        let string = evolutionChain.url
        let range = NSRange(location: 0, length: string.utf16.count)
        let regex = try? NSRegularExpression(pattern: "\\/(\\d+)\\/$")
        
        if let match = regex?.firstMatch(in: string, range: range),
           let matchRange = Range(match.range(at: 1), in: string),
           let intValue = Int(string[matchRange]) {
            return intValue
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

struct URLObject: Decodable {
    let url: String
}
