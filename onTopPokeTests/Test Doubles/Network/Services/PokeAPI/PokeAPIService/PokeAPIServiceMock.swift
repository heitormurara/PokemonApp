@testable import onTopPoke

final class PokeAPIServiceMock: PokeAPIServicing {
    var gotImages = false
    var getImagesCount = 0
    
    var gotImage = false
    var getImageCount = 0
    
    func getImages(for species: [onTopPoke.PokemonSpecieListItem],
                   completion: @escaping (onTopPoke.PokemonListItemList) -> Void) {
        gotImages = true
        getImagesCount += 1
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (onTopPoke.DataResult) -> Void) {
        gotImage = true
        getImageCount += 1
    }
}
