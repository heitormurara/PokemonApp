import Foundation

protocol SpeciesListPresenting {
    var species: [PokemonSpecieListItem] { get }
    func getSpecies()
}


final class SpeciesListPresenter {
    weak private var viewControllerDelegate: SpeciesListViewControllerDelegate?
    private let provider: NetworkServiceProviding
    
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
        let service = PokemonService.getSpecies(limit: 20, offset: 0)
        provider.request(service) { [weak self] (result: PokemonSpeciesListResult) in
            switch result {
            case let .success(paginatedResult):
                self?.species.append(contentsOf: paginatedResult.results)
                DispatchQueue.main.async {
                    self?.viewControllerDelegate?.reloadData()
                }
            case .failure: break
            }
        }
    }
}
