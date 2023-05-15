enum PokemonRoute {
    case getSpecies(_ page: Page)
    case getSpecie(fromSpecieId: Int)
    case getEvolutionChain(fromChainId: Int)
}

extension PokemonRoute: NetworkRoute {
    var baseURL: String {
        switch self {
        case .getSpecies, .getSpecie, .getEvolutionChain:
            return "https://pokeapi.co"
        }
    }
    
    var path: String {
        switch self {
        case .getSpecies:
            return "/api/v2/pokemon-species"
        case let .getSpecie(specieId):
            return "/api/v2/pokemon-species/\(specieId)"
        case let .getEvolutionChain(chainId):
            return "/api/v2/evolution-chain/\(chainId)"
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case let .getSpecies(page):
            return ["limit": String(page.limit), "offset": String(page.offset)]
        case .getSpecie, .getEvolutionChain:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSpecies, .getSpecie, .getEvolutionChain:
            return .get
        }
    }
}
