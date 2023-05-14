import UIKit

typealias PokemonSpecieItemList = [PokemonSpecieItem]

protocol PokeAPIServicing {
    func getImages(for species: [PokemonSpecieItem],
                   completion: @escaping (PokemonSpecieItemList) -> Void)
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (DataResult) -> Void)
}

final class PokeAPIService {
    private let networkProvider: NetworkProviding
    private let dispatchGroup: DispatchingGroup
    
    private let networkRoute = PokeAPIRoute.self
    
    init(networkProvider: NetworkProviding = NetworkProvider(),
         dispatchGroup: DispatchingGroup = DispatchGroup()) {
        self.networkProvider = networkProvider
        self.dispatchGroup = dispatchGroup
    }
}

extension PokeAPIService: PokeAPIServicing {
    func getImages(for species: [PokemonSpecieItem],
                   completion: @escaping (PokemonSpecieItemList) -> Void) {
        var updatedSpecies = [PokemonSpecieItem]()
        
        species.forEach { [weak self] specie in
            guard let specieId = specie.id, let self = self else { return }
            var updatedSpecie = specie
            self.dispatchGroup.enter()
            
            self.getImage(fromSpecieId: specieId, completion: { result in
                defer { self.dispatchGroup.leave() }
                
                switch result {
                case let .success(data):
                    updatedSpecie.image = UIImage(data: data)
                    updatedSpecies.append(updatedSpecie)
                case .failure: break
                }
            })
        }
        
        dispatchGroup.notify(on: .global(qos: .userInitiated)) {
            completion(updatedSpecies)
        }
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (DataResult) -> Void) {
        networkProvider.requestData(networkRoute.getImage(fromSpecieId: specieId), completion: completion)
    }
}
