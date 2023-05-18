protocol SpecieDetailsPresenting {
    var specie: Specie { get }
    var specieChain: [Specie]? { get }
    func viewDidLoad() async
}

final class SpecieDetailsPresenter: SpecieDetailsPresenting {
    weak var viewControllerDelegate: SpecieDetailsViewControllerDelegate?
    
    private let pokeAPIService: PokeAPIServicing
    private let dispatcher: Dispatching
    
    private var isLoading: Bool = false
    
    let specie: Specie
    var specieChain: [Specie]?
    
    init(specie: Specie,
         pokeAPIService: PokeAPIServicing = PokeAPIService(),
         dispatcher: Dispatching) {
        self.specie = specie
        self.pokeAPIService = pokeAPIService
        self.dispatcher = dispatcher
    }
    
    func viewDidLoad() async {
        defer { isLoading = false }
        isLoading = true
        await viewControllerDelegate?.displayLoading(true)
        
        guard case let .success(specieDetails) = await pokeAPIService.getSpecie(withID: specie.id),
              case let .success(species) = await pokeAPIService.getEvolutionChain(withID: specieDetails.evolutionChainID)
        else {
            let model = GenericUnknownEmptyStateModel(actionHandler: viewDidLoad)
            await viewControllerDelegate?.displayError(with: model)
            return
        }
        
        specieChain = species
        await viewControllerDelegate?.displayLoading(false)
        await viewControllerDelegate?.display()
    }
}
