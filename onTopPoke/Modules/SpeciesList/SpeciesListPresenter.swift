import UIKit

protocol SpeciesListPresenting {
    var species: [PokemonSpecieListItem] { get }
    func getSpecies()
}


final class SpeciesListPresenter {
    weak private var viewControllerDelegate: SpeciesListViewControllerDelegate?
    
    private let pokeAPIService: PokeAPIServicing
    private let pokemonService: PokemonServicing
    private var paginationManager: PaginationManaging
    
    var species: [PokemonSpecieListItem] = []
    
    init(viewControllerDelegate: SpeciesListViewControllerDelegate? = nil,
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         pokemonService: PokemonServicing = PokemonService(),
         paginationManager: PaginationManaging = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: false)) {
        self.viewControllerDelegate = viewControllerDelegate
        self.pokeAPIService = pokeAPIService
        self.pokemonService = pokemonService
        self.paginationManager = paginationManager
    }
}


// MARK: - SpeciesListPresenting

extension SpeciesListPresenter: SpeciesListPresenting {
    func getSpecies() {
        guard !paginationManager.isLoading, let nextPage = paginationManager.nextPage else { return }
        paginationManager.isLoading = true
        viewControllerDelegate?.showFooterSpinnerView(true)
        
        pokemonService.getSpecies(page: nextPage) { [weak self] (result: PokemonSpecieListItemPaginatedResult) in
            switch result {
            case let .success(paginatedResult):
                self?.paginationManager.nextPage = paginatedResult.next
                self?.getImages(from: paginatedResult.results)
            case .failure:
                break
            }
        }
    }
    
    private func getImages(from species: [PokemonSpecieListItem]) {
        pokeAPIService.getImages(for: species) { [weak self] species in
            guard let self = self else { return }
            defer { self.paginationManager.isLoading = false }
            
            DispatchQueue.main.async {
                self.species.append(contentsOf: species)
                self.viewControllerDelegate?.showFooterSpinnerView(false)
                self.viewControllerDelegate?.reloadData()
            }
        }
    }
}
