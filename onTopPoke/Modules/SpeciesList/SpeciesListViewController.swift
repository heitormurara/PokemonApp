import UIKit

protocol SpeciesListViewControllerDelegate: AnyObject {
    func reloadData()
}

final class SpeciesListViewController: UIViewController {
    var presenter: SpeciesListPresenting?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter = SpeciesListPresenter(viewControllerDelegate: self)
        presenter?.getSpecies()
    }
}


// MARK: - SpeciesListViewControllerDelegate

extension SpeciesListViewController: SpeciesListViewControllerDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}


// MARK: - UITableViewDelegate

extension SpeciesListViewController: UITableViewDelegate {
    
}


// MARK: - UITableViewDataSource

extension SpeciesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let species = presenter?.species else { return 0 }
        return species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if let specie = presenter?.species[indexPath.row] {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = specie.name
            cell.contentConfiguration = contentConfiguration
        }
        
        return cell
    }
}



// MARK: - Private API

extension SpeciesListViewController {
    private func setUp() {
        setUpConstraints()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
