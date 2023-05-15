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
    }
}
