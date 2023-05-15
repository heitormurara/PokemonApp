import Foundation

typealias SpeciePaginatedResult = Result<PaginatedResult<Specie>, Error>
typealias SpecieDetailsResult = Result<SpecieDetails, Error>
typealias EvolutionChainResponseResult = Result<EvolutionChainResponse, Error>

protocol PokemonServicing {
    func getSpecies(page: Page,
                    completion: @escaping (SpeciePaginatedResult) -> Void)
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (SpecieDetailsResult) -> Void)
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (EvolutionChainResponseResult) -> Void)
}

final class PokemonService {
    private let networkProvider: NetworkProviding
    private let networkRoute = PokemonRoute.self
    
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    var success = false
}

extension PokemonService: PokemonServicing {
    func getSpecies(page: Page,
                    completion: @escaping (SpeciePaginatedResult) -> Void) {
        networkProvider.request(networkRoute.getSpecies(page)) { (result: SpeciePaginatedResult) in
            switch result {
            case let .success(paginatedResult):
                sleep(2)
                if self.success {
                    completion(.success(paginatedResult))
                } else {
                    self.success = true
                    completion(.failure(NetworkProviderError.emptyData))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (SpecieDetailsResult) -> Void) {
        networkProvider.request(networkRoute.getSpecie(fromSpecieId: specieId), completion: completion)
    }
    
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (EvolutionChainResponseResult) -> Void) {
        networkProvider.request(networkRoute.getEvolutionChain(fromChainId: chainId), completion: completion)
    }
}
