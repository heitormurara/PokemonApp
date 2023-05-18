import UIKit

@MainActor
protocol SpeciesListViewControllerDelegate: AnyObject {
    func reloadData()
    func displayLoading(_ isVisible: Bool)
    func displayFooterSpinner(_ isVisible: Bool)
    func displayError(with model: EmptyStateModelling)
}

final class SpeciesListViewController: UIViewController {
    let presenter: SpeciesListPresenting
    
    private lazy var collectionView: UICollectionView = {
        let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let layout = CollectionViewColumnFlowLayout(cellsPerRow: 2,
                                                    minimumInteritemSpacing: 8,
                                                    minimumLineSpacing: 8,
                                                    sectionInset: sectionInsets)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        let reuseIdentifier = ImageTitleCollectionViewCell.reuseIdentifier
        collectionView.register(ImageTitleCollectionViewCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
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
        spinner.startAnimating()
        
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
        collectionView.reloadData()
    }
    
    func displayLoading(_ isVisible: Bool) {
        isVisible ? loadingView.startAnimating() : loadingView.stopAnimating()
    }
    
    func displayFooterSpinner(_ isVisible: Bool) {
//        tableView.tableFooterView = isVisible ? footerSpinnerView : nil
    }
    
    func displayError(with model: EmptyStateModelling) {
        emptyStateView.show(in: self, with: model)
    }
}


// MARK: - UITableViewDelegate

extension SpeciesListViewController: UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UITableViewDataSource

extension SpeciesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = ImageTitleCollectionViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                              for: indexPath)
        guard let cell = reusableCell as? ImageTitleCollectionViewCell else {
            return reusableCell
        }
        
        let specie = presenter.dataSource[indexPath.row]
        cell.set(image: specie.image!, title: specie.name.capitalized)
        return cell
    }
}



// MARK: - Private API

extension SpeciesListViewController {
    private func setUp() {
        setUpConstraints()
        view.backgroundColor = .systemGray6
        title = String(LocalizedString.speciesListTitle)
    }
    
    private func setUpConstraints() {
        view.addSubview(collectionView)
        collectionView.constraints(equalTo: view)
    }
}
