@testable import onTopPoke

final class PokemonServiceDummy: PokemonServicing {
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.SpeciePaginatedResult) -> Void) {}
    
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (onTopPoke.SpecieDetailsResult) -> Void) {}
    
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (onTopPoke.EvolutionChainResponseResult) -> Void) {}
}
