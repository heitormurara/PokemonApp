import Foundation

protocol SpeciesListPresenting {
    var species: [Specie] { get }
    func getSpecies()
    func displayDetails(ofSpecieAt indexPath: IndexPath)
}

final class SpeciesListPresenter {
    weak var viewControllerDelegate: SpeciesListViewControllerDelegate?
    var coordinator: SpeciesListCoordinating?
    
    private let pokeAPIService: PokeAPIServicing
    private let pokemonService: PokemonServicing
    
    private var paginationManager: PaginationManaging
    private let dispatcher: Dispatching
    
    var species: [Specie] = []
    
    init(pokeAPIService: PokeAPIServicing = PokeAPIService(),
         pokemonService: PokemonServicing = PokemonService(),
         paginationManager: PaginationManaging = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: false),
         dispatcher: Dispatching) {
        self.pokeAPIService = pokeAPIService
        self.pokemonService = pokemonService
        self.paginationManager = paginationManager
        self.dispatcher = dispatcher
    }
}


// MARK: - SpeciesListPresenting

extension SpeciesListPresenter: SpeciesListPresenting {
    func getSpecies() {
        guard !paginationManager.isLoading, let nextPage = paginationManager.nextPage else { return }
        paginationManager.isLoading = true
        viewControllerDelegate?.showFooterSpinnerView(true)
        
        pokemonService.getSpecies(page: nextPage) { [weak self] (result: SpeciePaginatedResult) in
            switch result {
            case let .success(paginatedResult):
                self?.paginationManager.nextPage = paginatedResult.next
                self?.getImages(from: paginatedResult.results)
            case .failure:
                break
            }
        }
    }
    
    private func getImages(from species: [Specie]) {
        pokeAPIService.getImages(for: species) { [weak self] species in
            guard let self = self else { return }
            defer { self.paginationManager.isLoading = false }
            
            dispatcher.async {
                self.species.append(contentsOf: species)
                self.viewControllerDelegate?.showFooterSpinnerView(false)
                self.viewControllerDelegate?.reloadData()
            }
        }
    }
    
    func displayDetails(ofSpecieAt indexPath: IndexPath) {
        let specie = species[indexPath.row]
        coordinator?.displayDetails(of: specie)
    }
}
