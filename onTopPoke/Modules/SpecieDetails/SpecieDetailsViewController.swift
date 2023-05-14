import UIKit

final class SpecieDetailsViewController: UIViewController {
    var presenter: SpecieDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SpecieDetailsPresenter()
        setUp()
        setUpConstraints()
    }
}


// MARK: - Private API

extension SpecieDetailsViewController {
    private func setUp() {
        
    }
    
    private func setUpConstraints() {
        
    }
}
