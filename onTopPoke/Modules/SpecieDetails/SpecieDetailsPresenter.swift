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
        
        let result = await pokeAPIService.getEvolutionChain(forSpecieID: specie.id)
        
        await viewControllerDelegate?.displayLoading(false)
        
        switch result {
        case let .success(species):
            self.specieChain = species
            await viewControllerDelegate?.display()
        case .failure:
            let model = GenericUnknownEmptyStateModel(actionHandler: viewDidLoad)
            await viewControllerDelegate?.displayError(with: model)
        }
    }
}
