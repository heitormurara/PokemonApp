import Foundation
@testable import onTopPoke

final class PokemonServiceStub: PokemonServicing {
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.SpeciePaginatedResult) -> Void) {
        let decoded: PaginatedResult<Specie> = JSONReader().getFromFile(named: "speciePaginatedResult")
        completion(.success(decoded))
    }
    
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (onTopPoke.SpecieDetailsResult) -> Void) {}
    
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (onTopPoke.EvolutionChainResponseResult) -> Void) {}
}
