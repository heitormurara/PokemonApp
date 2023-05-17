import UIKit

@MainActor
protocol SpecieDetailsViewControllerDelegate: AnyObject {
    func display()
    func displayLoading(_ isVisible: Bool)
    func displayError()
}

final class SpecieDetailsViewController: UIViewController {
    let presenter: SpecieDetailsPresenting
    
    private lazy var imageView = UIImageView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        return tableView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let label = UILabel()
        label.text = "Evolution Chain"
        label.font = .boldSystemFont(ofSize: 24)
        
        let (_, containerView) = label.inContainer()
        label
            .constraint(.leading, .trailing, equalTo: containerView, constant: 16)
            .constraint(.top, .bottom, equalTo: containerView)
        
        return containerView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .systemGray
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center(equalTo: view)
        
        return activityIndicatorView
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
        
        Task.detached { [weak self] in
            await self?.presenter.viewDidLoad()
        }
    }
}


// MARK: - SpecieDetailsViewControllerDelegate

extension SpecieDetailsViewController: SpecieDetailsViewControllerDelegate {
    func display() {
        tableView.isHidden = false
        
        title = presenter.specie.name.capitalized
        imageView.image = presenter.specie.image
        tableView.reloadData()
    }
    
    func displayLoading(_ isVisible: Bool) {
        isVisible ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func displayError() {
        tableView.isHidden = true
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
        view.addSubviews(imageView, tableView)
        
        imageView
            .top(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
            .centerX(equalTo: view.centerXAnchor)
        
        tableView
            .constraint(.leading, .trailing, .bottom, equalTo: view)
            .top(equalTo: imageView.bottomAnchor, constant: 24)
    }
}
