import Foundation

protocol SpeciesListCoordinating {
    func start()
    func displayDetails(of specie: Specie)
}

final class SpeciesListCoordinator: SpeciesListCoordinating {
    weak private var navigationController: NavigationControlling?
    var detailsCoordinator: SpecieDetailsCoordinating?
    
    init(navigationController: NavigationControlling? = nil) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = SpeciesListPresenter(dispatcher: DispatchQueue.main)
        let viewController = SpeciesListViewController(presenter: presenter)
        presenter.viewControllerDelegate = viewController
        presenter.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func displayDetails(of specie: Specie) {
        if detailsCoordinator == nil {
            detailsCoordinator = SpecieDetailsCoordinator(navigationController: navigationController)
        }
        
        detailsCoordinator?.start(with: specie)
    }
}
