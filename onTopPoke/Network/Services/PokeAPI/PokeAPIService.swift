import UIKit

typealias PokemonListItemList = [PokemonSpecieListItem]

protocol PokeAPIServicing {
    func getImages(for species: [PokemonSpecieListItem],
                   completion: @escaping (PokemonListItemList) -> Void)
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (DataResult) -> Void)
}

final class PokeAPIService {
    private let networkProvider: NetworkProviding
    private let networkRoute = PokeAPIRoute.self
    
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
    }
}

extension PokeAPIService: PokeAPIServicing {
    func getImages(for species: [PokemonSpecieListItem],
                   completion: @escaping (PokemonListItemList) -> Void) {
        let dispatchGroup = DispatchGroup()
        var updatedSpecies = [PokemonSpecieListItem]()
        
        species.forEach { [weak self] specie in
            guard let specieId = specie.id else { return }
            var updatedSpecie = specie
            dispatchGroup.enter()
            
            self?.getImage(fromSpecieId: specieId, completion: { result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case let .success(data):
                    updatedSpecie.image = UIImage(data: data)
                    updatedSpecies.append(updatedSpecie)
                case .failure: break
                }
            })
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            completion(updatedSpecies)
        }
    }
    
    func getImage(fromSpecieId specieId: Int,
                  completion: @escaping (DataResult) -> Void) {
        networkProvider.requestData(networkRoute.getImage(fromSpecieId: specieId), completion: completion)
    }
}
