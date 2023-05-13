enum PokemonService {
    case getSpecies(limit: Int, offset: Int)
}

extension PokemonService: NetworkService {
    var baseURL: String {
        switch self {
        case .getSpecies:
            return "https://pokeapi.co"
        }
    }
    
    var path: String {
        switch self {
        case .getSpecies:
            return "/api/v2/pokemon-species"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .getSpecies(limit, offset):
            return ["limit": limit, "offset": offset]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSpecies:
            return .get
        }
    }
}

typealias PokemonSpeciesListResult = Result<PaginatedResult<PokemonSpecieListItem>, Error>
