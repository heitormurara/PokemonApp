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
    
    let specie: Specie
    private(set) var specieChain: [Specie]?
    var isLoading: Bool = false
    
    init(specie: Specie,
         pokemonService: PokemonServicing = PokemonService(),
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         dispatcher: Dispatching) {
        self.specie = specie
        self.pokemonService = pokemonService
        self.pokeAPIService = pokeAPIService
        self.dispatcher = dispatcher
    }
}


// MARK: - SpecieDetailsPresenting

extension SpecieDetailsPresenter: SpecieDetailsPresenting {
    func getDetails() {
        guard !isLoading, let specieId = specie.id else { return }
        startLoading()
        
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
            self.specieChain = species
            
            dispatcher.async {
                self.stopLoading()
                self.viewControllerDelegate?.display()
            }
        }
    }
}


// MARK: - LoadManaging

extension SpecieDetailsPresenter: LoadManaging {
    func startLoading() {
        isLoading = true
        viewControllerDelegate?.displayLoading(true)
    }
    
    func stopLoading() {
        isLoading = false
        viewControllerDelegate?.displayLoading(false)
    }
}
