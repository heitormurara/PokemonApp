import UIKit

protocol SpeciesListViewControllerDelegate: AnyObject {
    func reloadData()
    func displayFooterSpinner(_ isVisible: Bool)
    func pushViewController(_ viewController: UIViewController)
}

final class SpeciesListViewController: UIViewController {
    let presenter: SpeciesListPresenting
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var footerSpinnerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    init(presenter: SpeciesListPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.getSpecies()
    }
}


// MARK: - SpeciesListViewControllerDelegate

extension SpeciesListViewController: SpeciesListViewControllerDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func displayFooterSpinner(_ isVisible: Bool) {
        tableView.tableFooterView = isVisible ? footerSpinnerView : nil
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UITableViewDelegate

extension SpeciesListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffset > contentHeight - frameHeight - 100 {
            presenter.getSpecies()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.displayDetails(ofSpecieAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension SpeciesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SpeciesListCell")
        
        let specie = presenter.species[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = specie.name.capitalized
        contentConfiguration.image = specie.image
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }
}



// MARK: - Private API

extension SpeciesListViewController {
    private func setUp() {
        setUpConstraints()
        
        view.backgroundColor = .systemBackground
        title = "Pokémon Species"
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
