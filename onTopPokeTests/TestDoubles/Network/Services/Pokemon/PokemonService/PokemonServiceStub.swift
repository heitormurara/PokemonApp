import Foundation
@testable import onTopPoke

final class PokemonServiceStub: PokemonServicing {
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.PokemonSpecieItemPaginatedResult) -> Void) {
        let decoded: PaginatedResult<PokemonSpecieItem> = JSONReader().getFromFile(named: "pokemonSpecieItemPaginatedResult")
        completion(.success(decoded))
    }
}
