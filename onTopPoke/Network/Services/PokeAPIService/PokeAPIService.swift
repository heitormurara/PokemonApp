import Foundation

enum PokeAPIService {
    case getImage(fromSpecieId: Int)
}

extension PokeAPIService: NetworkService {
    var baseURL: String {
        switch self {
        case .getImage:
            return "https://raw.githubusercontent.com"
        }
    }
    
    var path: String {
        switch self {
        case let .getImage(specieId):
            return "/PokeAPI/sprites/master/sprites/pokemon/\(specieId).png"
        }
    }
    
    var parameters: [String : String]? {
        nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .getImage:
            return .get
        }
    }
}
