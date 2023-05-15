@testable import onTopPoke

final class PokeAPIServiceDummy: PokeAPIServicing {
    func getImages(for species: [onTopPoke.Specie],
                   completion: @escaping (onTopPoke.SpecieList) -> Void) {}
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (onTopPoke.DataResult) -> Void) {}
}
