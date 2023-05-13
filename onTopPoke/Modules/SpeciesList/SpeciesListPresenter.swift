import UIKit

protocol SpeciesListPresenting {
    var species: [PokemonSpecieListItem] { get }
    func getSpecies()
}


final class SpeciesListPresenter {
    weak private var viewControllerDelegate: SpeciesListViewControllerDelegate?
    private let provider: NetworkServiceProviding
    private var nextPage: Page? = Page(limit: 20, offset: 0)
    private var isLoading: Bool = false
    
    var species: [PokemonSpecieListItem] = []
    
    init(viewControllerDelegate: SpeciesListViewControllerDelegate? = nil,
         provider: NetworkServiceProviding = NetworkServiceProvider()) {
        self.viewControllerDelegate = viewControllerDelegate
        self.provider = provider
    }
}


// MARK: - SpeciesListPresenting

extension SpeciesListPresenter: SpeciesListPresenting {
    func getSpecies() {
        guard !isLoading else { return }
        isLoading = true
        
        getSpeciesList { [weak self] (result: PokemonSpeciesListResult) in
            defer { self?.isLoading = false }
            
            switch result {
            case let .success(paginatedResult):
                self?.nextPage = paginatedResult.next
                
                self?.getImages(for: paginatedResult.results, completion: { species in
                    DispatchQueue.main.async { [weak self] in
                        self?.species.append(contentsOf: species)
                        self?.viewControllerDelegate?.reloadData()
                    }
                })
            case .failure: break
            }
        }
    }
}


// MARK: - Private API

extension SpeciesListPresenter {
    private func getSpeciesList(completion: @escaping (PokemonSpeciesListResult) -> Void) {
        guard let nextPage = nextPage else { return }
        let service = PokemonService.getSpecies(nextPage)
        provider.request(service, completion: completion)
    }
    
    private func getImages(for species: [PokemonSpecieListItem], completion: @escaping ([PokemonSpecieListItem]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var updatedSpecies = [PokemonSpecieListItem]()
        
        species.forEach { [weak self] specie in
            var updatedSpecie = specie
            dispatchGroup.enter()
            
            self?.getImage(for: specie, completion: { result in
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
    
    private func getImage(for specie: PokemonSpecieListItem, completion: @escaping (DataResult) -> Void) {
        guard let specieId = specie.id else { return }
        let service = PokeAPIService.getImage(fromSpecieId: specieId)
        provider.requestData(service, completion: completion)
    }
}
