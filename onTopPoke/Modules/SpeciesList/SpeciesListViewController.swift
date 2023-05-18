import UIKit

@MainActor
protocol SpeciesListViewControllerDelegate: AnyObject {
    func reloadData()
    func displayLoading(_ isVisible: Bool)
    func displayFooterSpinner(_ isVisible: Bool)
    func displayError(with model: EmptyStateModel)
}

final class SpeciesListViewController: UIViewController {
    let presenter: SpeciesListPresenting
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .systemGray
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center(equalTo: view)
        
        return activityIndicatorView
    }()
    
    private lazy var footerSpinnerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        containerView.setConstrainable()
        
        let spinner = UIActivityIndicatorView()
        spinner.center = containerView.center
        
        containerView.addSubview(spinner)
        return containerView
    }()
    
    private let emptyStateView = EmptyStateView()
    
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
        
        Task.detached { [weak self] in
            await self?.presenter.viewDidLoad()
        }
    }
}


// MARK: - SpeciesListViewControllerDelegate

extension SpeciesListViewController: SpeciesListViewControllerDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func displayLoading(_ isVisible: Bool) {
        isVisible ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func displayFooterSpinner(_ isVisible: Bool) {
        tableView.tableFooterView = isVisible ? footerSpinnerView : nil
    }
    
    func displayError(with model: EmptyStateModel) {
        emptyStateView.show(in: self, with: model)
    }
}


// MARK: - UITableViewDelegate

extension SpeciesListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffset > contentHeight - frameHeight - 100 {
            Task.detached { [weak self] in
                await self?.presenter.viewDidScroll()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension SpeciesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SpeciesListCell")
        
        let specie = presenter.dataSource[indexPath.row]
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
        tableView.constraints(equalTo: view)
    }
}
