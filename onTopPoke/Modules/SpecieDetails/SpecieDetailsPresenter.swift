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
    
    init(specieItem: Specie,
         pokemonService: PokemonServicing = PokemonService(),
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         dispatcher: Dispatching) {
        self.specie = specieItem
        self.pokemonService = pokemonService
        self.pokeAPIService = pokeAPIService
        self.dispatcher = dispatcher
    }
}


// MARK: - SpecieDetailsPresenting

extension SpecieDetailsPresenter: SpecieDetailsPresenting {
    func getDetails() {
        guard let specieId = specie.id else { return }
        
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
                self.viewControllerDelegate?.reloadData()
            }
        }
    }
}
