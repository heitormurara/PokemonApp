import Foundation

protocol SpeciesListPresenting {
    var species: [Specie] { get }
    func getSpecies()
    func displayDetails(ofSpecieAt indexPath: IndexPath)
}

final class SpeciesListPresenter {
    static private let firstPage = Page(limit: 20, offset: 0)
    
    private let pokeAPIService: PokeAPIServicing
    private let pokemonService: PokemonServicing
    private let dispatcher: Dispatching
    private var paginationManager: PaginationManaging
    
    weak var viewControllerDelegate: SpeciesListViewControllerDelegate?
    var coordinator: SpeciesListCoordinating?
    var species: [Specie] = []
    var isLoading: Bool = false
    
    init(pokeAPIService: PokeAPIServicing = PokeAPIService(),
         pokemonService: PokemonServicing = PokemonService(),
         paginationManager: PaginationManaging = PaginationManager(nextPage: firstPage),
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
        guard !isLoading, let nextPage = paginationManager.nextPage else { return }
        startLoading()
        
        pokemonService.getSpecies(page: nextPage) { [weak self] (result: SpeciePaginatedResult) in
            guard let self = self else { return }
            
            switch result {
            case let .success(paginatedResult):
                self.paginationManager.nextPage = paginatedResult.next
                self.getImages(from: paginatedResult.results)
            case .failure:
                dispatcher.async {
                    self.stopLoading()
                    self.viewControllerDelegate?.displayError()
                }
            }
        }
    }
    
    func displayDetails(ofSpecieAt indexPath: IndexPath) {
        let specie = species[indexPath.row]
        coordinator?.displayDetails(of: specie)
    }
}


// MARK: - Private API

extension SpeciesListPresenter {
    private func getImages(from species: [Specie]) {
        pokeAPIService.getImages(for: species) { [weak self] species in
            guard let self = self else { return }
            
            dispatcher.async {
                self.stopLoading()
                self.species.append(contentsOf: species)
                self.viewControllerDelegate?.reloadData()
            }
        }
    }
}


// MARK: - LoadManaging

extension SpeciesListPresenter: LoadManaging {
    func startLoading() {
        isLoading = true
        
        if species.isEmpty {
            viewControllerDelegate?.displayLoading(true)
        } else {
            viewControllerDelegate?.displayFooterSpinner(true)
        }
    }
    
    func stopLoading() {
        isLoading = false
        viewControllerDelegate?.displayLoading(false)
        viewControllerDelegate?.displayFooterSpinner(false)
    }
}
