import UIKit

final class SpecieCollectionViewCell: UICollectionViewCell, Reusable {
    private let imageView = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    func set(image: UIImage, name: String) {
        imageView.image = image
        nameLabel.text = name.capitalized
    }
}

extension SpecieCollectionViewCell {
    private func setUp() {
        setUpConstraints()
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
    }
    
    private func setUpConstraints() {
        addSubviews(imageView, nameLabel)
        
        imageView
            .centerX(equalTo: centerXAnchor)
            .top(equalTo: topAnchor, constant: 8)

        nameLabel
            .constraint(.leading, .trailing, .bottom, equalTo: self)
            .top(equalTo: imageView.bottomAnchor)
    }
}
