import UIKit

protocol SpeciesListPresenting {
    var dataSource: [Specie] { get }
    func viewDidLoad() async
    func viewDidScroll() async
    func didSelectRow(at indexPath: IndexPath)
}

final class SpeciesListPresenter: SpeciesListPresenting {
    weak var viewControllerDelegate: SpeciesListViewControllerDelegate?
    var coordinator: SpeciesListCoordinating?
    
    private let pokeAPIService: PokeAPIServicing
    private let dispatcher: Dispatching
    private var paginationManager: PaginationManaging
    
    var dataSource: [Specie] = []
    var isLoading: Bool = false
    
    init(pokeAPIService: PokeAPIServicing = PokeAPIService(),
         paginationManager: PaginationManaging = PaginationManager(nextPage: Page(limit: 20, offset: 0)),
         dispatcher: Dispatching) {
        self.pokeAPIService = pokeAPIService
        self.paginationManager = paginationManager
        self.dispatcher = dispatcher
    }
    
    func viewDidLoad() async {
        guard !isLoading, let nextPage = paginationManager.nextPage else { return }
        
        defer { isLoading = false }
        isLoading = true
        await viewControllerDelegate?.displayLoading(true)
        
        if case let .success(paginated) = await pokeAPIService.getSpecies(at: nextPage)  {
            paginationManager.nextPage = paginated.nextPage
            dataSource = paginated.array
            await viewControllerDelegate?.reloadData()
        } else {
            let model = GenericUnknownEmptyStateModel(actionHandler: viewDidLoad)
            await viewControllerDelegate?.displayError(with: model)
        }
        
        await viewControllerDelegate?.displayLoading(false)
        
    }
    
    func viewDidScroll() async {
        guard !isLoading, let nextPage = paginationManager.nextPage else { return }
        
        defer { isLoading = false }
        isLoading = true
        await viewControllerDelegate?.displayFooterSpinner(true)
        
        if case let .success(paginated) = await pokeAPIService.getSpecies(at: nextPage)  {
            paginationManager.nextPage = paginated.nextPage
            dataSource.append(contentsOf: paginated.array)
            await viewControllerDelegate?.reloadData()
        }
        
        await viewControllerDelegate?.displayFooterSpinner(false)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let specie = dataSource[indexPath.row]
        coordinator?.displayDetails(of: specie)
    }
}
