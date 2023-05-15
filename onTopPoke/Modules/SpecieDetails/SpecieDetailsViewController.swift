import UIKit

protocol SpecieDetailsViewControllerDelegate: AnyObject {
    func display()
    func displayLoading(_ isVisible: Bool)
    func displayError()
}

final class SpecieDetailsViewController: UIViewController {
    let presenter: SpecieDetailsPresenting
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Evolution Chain"
        label.font = .boldSystemFont(ofSize: 24)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .systemGray
        
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private lazy var errorView: RetriableErrorView = {
        let errorView = RetriableErrorView()
        let errorModel = RetriableErrorModel(image: .defaultError, text: "An issue ocurred while loading Pokémon Species.") { [weak self] in
            self?.errorView.isHidden = true
            self?.presenter.getDetails()
        }
        errorView.isHidden = true
        errorView.configure(with: errorModel)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()
    
    init(presenter: SpecieDetailsPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter.getDetails()
    }
}


// MARK: - SpecieDetailsViewControllerDelegate

extension SpecieDetailsViewController: SpecieDetailsViewControllerDelegate {
    func display() {
        tableView.isHidden = false
        errorView.isHidden = true
        
        title = presenter.specie.name.capitalized
        imageView.image = presenter.specie.image
        tableView.reloadData()
    }
    
    func displayLoading(_ isVisible: Bool) {
        isVisible ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func displayError() {
        tableView.isHidden = true
        errorView.isHidden = false
    }
}


// MARK: - UITableViewDataSource

extension SpecieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chainItems = presenter.specieChain else { return 0 }
        return chainItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ChainItemCell")
        
        if let specie = presenter.specieChain?[indexPath.row] {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = specie.name.capitalized
            contentConfiguration.image = specie.image
            cell.contentConfiguration = contentConfiguration
        }
        
        return cell
    }
}

// MARK: - Private API

extension SpecieDetailsViewController {
    private func setUp() {
        setUpConstraints()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
