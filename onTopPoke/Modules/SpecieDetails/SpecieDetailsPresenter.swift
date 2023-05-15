protocol SpecieDetailsPresenting {
    var specie: Specie { get }
    var specieChain: [Specie]? { get }
    func getDetails()
}

final class SpecieDetailsPresenter {
    weak var viewControllerDelegate: SpecieDetailsViewControllerDelegate?
    
    private let pokemonService: PokemonServicing
    private let pokeAPIService: PokeAPIServicing
    private let dispatcher: Dispatching
    
    private var loadManager: LoadManaging
    
    let specie: Specie
    private(set) var specieChain: [Specie]?
    
    init(specie: Specie,
         pokemonService: PokemonServicing = PokemonService(),
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         loadManager: LoadManaging = LoadManager(isLoading: false),
         dispatcher: Dispatching) {
        self.specie = specie
        self.pokemonService = pokemonService
        self.pokeAPIService = pokeAPIService
        self.loadManager = loadManager
        self.dispatcher = dispatcher
    }
}


// MARK: - SpecieDetailsPresenting

extension SpecieDetailsPresenter: SpecieDetailsPresenting {
    func getDetails() {
        guard !loadManager.isLoading, let specieId = specie.id else { return }
        loadManager.isLoading = true
        viewControllerDelegate?.displayLoading(true)
        
        pokemonService.getSpecie(fromSpecieId: specieId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(specieDetails):
                guard let evolutionChainId = specieDetails.evolutionChainId else { return }
                self.getEvolutionChain(fromChainId: evolutionChainId)
            case .failure: break
            }
        }
    }
    
    private func getEvolutionChain(fromChainId chainId: Int) {
        pokemonService.getEvolutionChain(fromChainId: chainId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(evolutionChainResponse):
                self.getImages(from: evolutionChainResponse.flatSpecieChain)
            case .failure: break
            }
        }
    }
    
    private func getImages(from species: [Specie]) {
        pokeAPIService.getImages(for: species) { [weak self] species in
            guard let self = self else { return }
            defer { self.loadManager.isLoading = false }
            self.specieChain = species
            
            dispatcher.async {
                self.viewControllerDelegate?.displayLoading(false)
                self.viewControllerDelegate?.display()
            }
        }
    }
}
