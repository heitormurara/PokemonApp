import UIKit
@testable import onTopPoke

final class SpeciesListViewControllerDummy: SpeciesListViewControllerDelegate {
    func reloadData() {}
    
    func showFooterSpinnerView(_ isVisible: Bool) {}
    
    func pushViewController(_ viewController: UIViewController) {}
}
