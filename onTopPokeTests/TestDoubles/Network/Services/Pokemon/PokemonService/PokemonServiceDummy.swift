@testable import onTopPoke

final class PokemonServiceDummy: PokemonServicing {
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.PokemonSpecieItemPaginatedResult) -> Void) {}
}
