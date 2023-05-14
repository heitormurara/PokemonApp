import Foundation
@testable import onTopPoke

final class PokeAPIServiceStub: PokeAPIServicing {
    enum GetImagesResponses: String {
        case successList = "pokemonSpecieItemList"
    }
    
    var getImagesResponse = GetImagesResponses.successList
    
    func getImages(for species: [onTopPoke.PokemonSpecieItem],
                   completion: @escaping (onTopPoke.PokemonSpecieItemList) -> Void) {
        let jsonResponse: PokemonSpecieItemList = JSONReader().getFromFile(named: getImagesResponse.rawValue)
        completion(jsonResponse)
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (onTopPoke.DataResult) -> Void) {
        completion(.success(Data()))
    }
}
