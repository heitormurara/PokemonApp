import UIKit

final class RetriableErrorView: UIView {
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var errorModel: RetriableErrorModel?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with errorModel: RetriableErrorModel) {
        self.errorModel = errorModel
        
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: .black)
        let image = UIImage(systemName: errorModel.image.rawValue, withConfiguration: configuration)
        
        imageView.image = image
        label.text = errorModel.text
    }
    
    @objc
    private func tryAgain() {
        errorModel?.tryAgainAction()
    }
}

extension RetriableErrorView {
    private func setUp() {
        setUpConstraints()
        backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        addSubview(imageView)
        addSubview(label)
        addSubview(tryAgainButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
        ])
    }
}
