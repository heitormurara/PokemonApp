import UIKit

struct Specie: Decodable {
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case urlString = "url"
    }
}
