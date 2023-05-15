import UIKit
@testable import onTopPoke

final class SpeciesListViewControllerMock: SpeciesListViewControllerDelegate {
    var reloadedData = false
    
    var didSetFooterSpinnerVisibility = false
    var didSetFooterSpinnerVisible = false
    var isFooterSpinnerVisible = false
    
    var didSetLoadingVisibility = false
    var isLoadingVisible = false
    
    func reloadData() {
        reloadedData = true
    }
    
    func displayLoading(_ isVisible: Bool) {
        didSetLoadingVisibility = true
        isLoadingVisible = isVisible
    }
    
    func displayFooterSpinner(_ isVisible: Bool) {
        didSetFooterSpinnerVisibility = true
        isFooterSpinnerVisible = isVisible
        
        if isVisible { didSetFooterSpinnerVisible = true  }
    }
    
    func displayError() {}
    
    func pushViewController(_ viewController: UIViewController) {}
}
