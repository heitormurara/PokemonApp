@testable import onTopPoke

final class PokemonServiceMock: PokemonServicing {
    var gotSpecies = false
    var getSpeciesCount = 0
    
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.PokemonSpecieItemPaginatedResult) -> Void) {
        gotSpecies = true
        getSpeciesCount += 1
    }
}
