import Foundation
@testable import onTopPoke

final class PokemonServiceStub: PokemonServicing {
    func getSpecies(page: onTopPoke.Page,
                    completion: @escaping (onTopPoke.PokemonSpecieListItemPaginatedResult) -> Void) {
        let decoded: PaginatedResult<PokemonSpecieListItem> = JSONReader().getFromFile(named: "getSpecies-valid")
        completion(.success(decoded))
    }
}
