import UIKit

struct PokemonSpecieItem: Decodable {
    let name: String
    private let urlString: String
    
    var id: Int? {
        let range = NSRange(location: 0, length: urlString.utf16.count)
        let regex = try? NSRegularExpression(pattern: "\\/(\\d+)\\/$")
        
        if let match = regex?.firstMatch(in: urlString, range: range),
           let matchRange = Range(match.range(at: 1), in: urlString),
           let intValue = Int(urlString[matchRange]) {
            return intValue
        }
        return nil
    }
    
    var image: UIImage?
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        urlString = try container.decode(String.self, forKey: .url)
    }
}
