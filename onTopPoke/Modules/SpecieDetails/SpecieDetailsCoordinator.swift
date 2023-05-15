import Foundation

protocol SpecieDetailsCoordinating {
    func start(with specie: Specie)
}

final class SpecieDetailsCoordinator: SpecieDetailsCoordinating {
    weak private var navigationController: NavigationControlling?
    
    init(navigationController: NavigationControlling? = nil) {
        self.navigationController = navigationController
    }
    
    func start(with specie: Specie) {
        let presenter = SpecieDetailsPresenter(specie: specie,
                                               dispatcher: DispatchQueue.main)
        let viewController = SpecieDetailsViewController(presenter: presenter)
        presenter.viewControllerDelegate = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}
