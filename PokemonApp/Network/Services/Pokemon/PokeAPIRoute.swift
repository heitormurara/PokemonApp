enum PokeAPIRoute {
    case getSpecies(page: Page)
    case getSpecie(specieID: Int)
    case getEvolutionChain(chainID: Int)
    case getImage(specieID: Int)
}

extension PokeAPIRoute: NetworkRoute {
    var baseURL: String {
        switch self {
        case .getSpecies, .getSpecie, .getEvolutionChain:
            return "https://pokeapi.co"
        case .getImage:
            return "https://raw.githubusercontent.com"
        }
    }
    
    var path: String {
        switch self {
        case .getSpecies:
            return "/api/v2/pokemon-species"
        case let .getSpecie(specieID):
            return "/api/v2/pokemon-species/\(specieID)"
        case let .getEvolutionChain(chainID):
            return "/api/v2/evolution-chain/\(chainID)"
        case let .getImage(specieID):
            return "/PokeAPI/sprites/master/sprites/pokemon/\(specieID).png"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case let .getSpecies(page):
            return ["limit": String(page.limit), "offset": String(page.offset)]
        case .getSpecie, .getEvolutionChain, .getImage:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSpecies, .getSpecie, .getEvolutionChain, .getImage:
            return .get
        }
    }
}
