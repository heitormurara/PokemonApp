@testable import onTopPoke

final class SpeciesListViewControllerMock: SpeciesListViewControllerDelegate {
    var reloadedData = false
    var setFooterSpinnerVisibility = false
    var isFooterSpinnerViewVisible = false
    
    func reloadData() {
        reloadedData = true
    }
    
    func showFooterSpinnerView(_ isVisible: Bool) {
        setFooterSpinnerVisibility = true
        isFooterSpinnerViewVisible = isVisible
    }
}