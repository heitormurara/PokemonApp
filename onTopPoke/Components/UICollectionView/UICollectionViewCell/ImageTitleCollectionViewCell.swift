import UIKit

final class ImageTitleCollectionViewCell: UICollectionViewCell, Reusable {
    private let imageView = UIImageView()
    
    private let titleLabel: UILabel = {
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
        titleLabel.text = nil
    }
    
    func set(image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}

extension ImageTitleCollectionViewCell {
    private func setUp() {
        setUpConstraints()
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
    }
    
    private func setUpConstraints() {
        addSubviews(imageView, titleLabel)
        
        imageView
            .centerX(equalTo: centerXAnchor)
            .top(equalTo: topAnchor, constant: 8)

        titleLabel
            .constraint(.leading, .trailing, .bottom, equalTo: self)
            .top(equalTo: imageView.bottomAnchor)
    }
}
