import UIKit
@testable import onTopPoke

final class SpeciesListViewControllerDummy: SpeciesListViewControllerDelegate {
    func reloadData() {}
    
    func displayLoading(_ isVisible: Bool) {}
    
    func displayFooterSpinner(_ isVisible: Bool) {}
    
    func displayError() {}
    
    func pushViewController(_ viewController: UIViewController) {}
}
