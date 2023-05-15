protocol SpecieDetailsPresenting {
    var specieItem: PokemonSpecieItem { get }
    var specieChain: [PokemonSpecieItem]? { get }
    func getDetails()
}

final class SpecieDetailsPresenter {
    weak var viewControllerDelegate: SpecieDetailsViewControllerDelegate?
    
    private let pokemonService: PokemonServicing
    private let pokeAPIService: PokeAPIServicing
    private let dispatcher: Dispatching
    
    let specieItem: PokemonSpecieItem
    private(set) var specieChain: [PokemonSpecieItem]?
    
    init(specieItem: PokemonSpecieItem,
         pokemonService: PokemonServicing = PokemonService(),
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         dispatcher: Dispatching) {
        self.specieItem = specieItem
        self.pokemonService = pokemonService
        self.pokeAPIService = pokeAPIService
        self.dispatcher = dispatcher
    }
}


// MARK: - SpecieDetailsPresenting

extension SpecieDetailsPresenter: SpecieDetailsPresenting {
    func getDetails() {
        guard let specieId = specieItem.id else { return }
        
        pokemonService.getSpecie(fromSpecieId: specieId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(specie):
                guard let evolutionChainId = specie.evolutionChainId else { return }
                self.getEvolutionChain(fromChainId: evolutionChainId)
            case .failure: break
            }
        }
    }
    
    private func getEvolutionChain(fromChainId chainId: Int) {
        pokemonService.getEvolutionChain(fromChainId: chainId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(chain):
                self.getImages(from: chain.flatSpecieChain)
            case .failure: break
            }
        }
    }
    
    private func getImages(from species: [PokemonSpecieItem]) {
        pokeAPIService.getImages(for: species) { [weak self] species in
            guard let self = self else { return }
            self.specieChain = species
            
            dispatcher.async {
                self.viewControllerDelegate?.reloadData()
            }
        }
    }
}
