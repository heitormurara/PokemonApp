import Foundation

struct SpecieDetails: Decodable {
    let evolutionChainID: Int
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let evolutionChain = try container.decode(URLObject.self, forKey: .evolutionChain)
        
        if let id = RegexInterpreter.idFromURL(evolutionChain.urlString) {
            self.evolutionChainID = id
        } else {
            throw NetworkProviderError.decodingError
        }
    }
}

struct URLObject: Decodable {
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
    }
}
