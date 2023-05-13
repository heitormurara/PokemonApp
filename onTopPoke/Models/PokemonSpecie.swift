import Foundation

struct PokemonSpecieListItem: Decodable {
    let name: String
    let url: URL?
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        let urlString = try container.decode(String.self, forKey: .url)
        url = URL(string: urlString)
    }
}
