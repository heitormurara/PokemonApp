@testable import onTopPoke

final class PokemonServiceMock: PokemonServicing {
    var gotSpecies = false
    var getSpeciesCount = 0
    
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.PokemonSpecieListItemPaginatedResult) -> Void) {
        gotSpecies = true
        getSpeciesCount += 1
    }
}
