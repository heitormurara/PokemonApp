import UIKit

final class EmptyStateView: UIView {
    private lazy var imageView = UIImageView()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.handleAction()
        }
        return UIButton(type: .system, primaryAction: action)
    }()
    
    private var model: EmptyStateModelling?
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in viewController: UIViewController, with model: EmptyStateModelling) {
        set(model)
        
        viewController.view.addSubview(self)
        constraints(equalTo: viewController.view)
    }
    
    func drop() {
        removeFromSuperview()
    }
}

extension EmptyStateView {
    private func setUp() {
        setUpConstraints()
        backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        addSubviews(imageView, label, actionButton)
        
        imageView.center(equalTo: self)
        
        label
            .centerX(equalTo: centerXAnchor)
            .top(equalTo: imageView.bottomAnchor, constant: 16)
        
        actionButton
            .centerX(equalTo: centerXAnchor)
            .top(equalTo: label.bottomAnchor, constant: 16)
    }
    
    private func set(_ model: EmptyStateModelling) {
        self.model = model
        imageView.image = model.image
        label.text = model.text
        actionButton.setTitle(model.actionTitle, for: .normal)
    }
    
    private func handleAction() {
        drop()
        
        Task.detached { [weak self] in
            await self?.model?.actionHandler()
        }
    }
}
