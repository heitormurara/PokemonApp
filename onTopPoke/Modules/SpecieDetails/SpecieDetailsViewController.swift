import UIKit

protocol SpecieDetailsViewControllerDelegate: AnyObject {
    func reloadData()
}

final class SpecieDetailsViewController: UIViewController {
    let presenter: SpecieDetailsPresenting
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: presenter.specieItem.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    func reloadData() {
        tableView.reloadData()
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
        title = presenter.specieItem.name.capitalized
    }
    
    private func setUpConstraints() {
        view.addSubview(imageView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
