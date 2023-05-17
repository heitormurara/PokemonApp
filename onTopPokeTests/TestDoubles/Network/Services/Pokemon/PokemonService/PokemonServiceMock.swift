@testable import onTopPoke

final class PokemonServiceMock: PokeAPIServicing {
    var gotSpecies = false
    var getSpeciesCount = 0
    
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.SpeciePaginatedResult) -> Void) {
        gotSpecies = true
        getSpeciesCount += 1
    }
    
    
    func getSpecie(fromSpecieId specieId: Int,
                   completion: @escaping (onTopPoke.SpecieDetailsResult) -> Void) {}
    
    func getEvolutionChain(fromChainId chainId: Int,
                           completion: @escaping (onTopPoke.EvolutionChainResponseResult) -> Void) {}
}
