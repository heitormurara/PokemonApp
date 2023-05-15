import Foundation
@testable import onTopPoke

final class PokeAPIServiceStub: PokeAPIServicing {
    enum GetImagesResponses: String {
        case successList = "specieList"
    }
    
    var getImagesResponse = GetImagesResponses.successList
    
    func getImages(for species: [onTopPoke.Specie],
                   completion: @escaping (onTopPoke.SpecieList) -> Void) {
        let jsonResponse: SpecieList = JSONReader().getFromFile(named: getImagesResponse.rawValue)
        completion(jsonResponse)
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (onTopPoke.DataResult) -> Void) {
        completion(.success(Data()))
    }
}
