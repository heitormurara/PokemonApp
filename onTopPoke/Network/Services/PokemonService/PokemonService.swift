enum PokemonService {
    case getSpecies(_ page: Page)
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
    
    var parameters: [String : String]? {
        switch self {
        case let .getSpecies(page):
            return ["limit": String(page.limit), "offset": String(page.offset)]
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
