import UIKit

struct Specie: Decodable, Equatable {
    let id: Int
    let name: String
    
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case name
        case urlString = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        let urlString = try container.decode(String.self, forKey: .urlString)
        if let id = RegexInterpreter.idFromURL(urlString) {
            self.id = id
        } else {
            throw NetworkProviderError.decodingError
        }
    }
    
    mutating func setImage(_ data: Data) {
        image = UIImage(data: data)
    }
}
