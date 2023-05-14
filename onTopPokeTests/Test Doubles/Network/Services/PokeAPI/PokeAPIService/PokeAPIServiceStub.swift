import Foundation
@testable import onTopPoke

final class PokeAPIServiceStub: PokeAPIServicing {
    enum GetImagesResponses: String {
        case successList = "pokemonListItemList"
    }
    
    var getImagesResponse = GetImagesResponses.successList
    
    func getImages(for species: [onTopPoke.PokemonSpecieListItem],
                   completion: @escaping (onTopPoke.PokemonListItemList) -> Void) {
        let jsonResponse: PokemonListItemList = JSONReader().getFromFile(named: getImagesResponse.rawValue)
        completion(jsonResponse)
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (onTopPoke.DataResult) -> Void) {
        completion(.success(Data()))
    }
}
