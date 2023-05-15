import UIKit
@testable import onTopPoke

final class SpeciesListViewControllerMock: SpeciesListViewControllerDelegate {
    var reloadedData = false
    var setFooterSpinnerVisibility = false
    var isFooterSpinnerViewVisible = false
    
    func reloadData() {
        reloadedData = true
    }
    
    func displayLoading(_ isVisible: Bool) {}
    
    func displayFooterSpinner(_ isVisible: Bool) {
        setFooterSpinnerVisibility = true
        isFooterSpinnerViewVisible = isVisible
    }
    
    func displayError() {}
    
    func pushViewController(_ viewController: UIViewController) {}
}
