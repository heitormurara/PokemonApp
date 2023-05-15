typealias PokemonSpecieItemPaginatedResult = Result<PaginatedResult<PokemonSpecieItem>, Error>
typealias PokemonSpecieResult = Result<PokemonSpecie, Error>
typealias PokemonChainItemResult = Result<PokemonChainResponse, Error>

protocol PokemonServicing {
    func getSpecies(page: Page,
                    completion: @escaping (PokemonSpecieItemPaginatedResult) -> Void)
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (PokemonSpecieResult) -> Void)
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (PokemonChainItemResult) -> Void)
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
    
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (PokemonSpecieResult) -> Void) {
        networkProvider.request(networkRoute.getSpecie(fromSpecieId: specieId), completion: completion)
    }
    
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (PokemonChainItemResult) -> Void) {
        networkProvider.request(networkRoute.getEvolutionChain(fromChainId: chainId), completion: completion)
    }
}
