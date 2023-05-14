typealias PokemonSpecieItemPaginatedResult = Result<PaginatedResult<PokemonSpecieItem>, Error>

protocol PokemonServicing {
    func getSpecies(page: Page,
                    completion: @escaping (PokemonSpecieItemPaginatedResult) -> Void)
}

final class PokemonService {
    private let networkProvider: NetworkProviding
    private let networkRoute = PokemonRoute.self
    
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
}

extension PokemonService: PokemonServicing {
    func getSpecies(page: Page,
                    completion: @escaping (PokemonSpecieItemPaginatedResult) -> Void) {
        networkProvider.request(networkRoute.getSpecies(page), completion: completion)
    }
}
