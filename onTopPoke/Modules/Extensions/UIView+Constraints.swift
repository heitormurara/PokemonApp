import UIKit

// MARK: - Property Updates

extension UIView {
    
    func setConstrainable() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}


// MARK: - Singular-Constraint setting

extension UIView {
    @discardableResult
    func leading(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailing(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func top(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerX(equalTo anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerY(equalTo anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
}


// MARK: - Plural-Constraint setting

extension UIView {
    enum Constraint {
        case leading, trailing, top, bottom, centerX, centerY
    }
    
    func constraints(equalTo view: UIView) {
        setConstrainable()
        
        leading(equalTo: view.leadingAnchor)
        trailing(equalTo: view.trailingAnchor)
        top(equalTo: view.topAnchor)
        bottom(equalTo: view.bottomAnchor)
    }
    
    @discardableResult
    func constraint(_ constraints: Constraint..., equalTo view: UIView, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        
        constraints.forEach { constraint in
            if constraint == .leading {
                leading(equalTo: view.leadingAnchor, constant: constant)
            }
            
            if constraint == .trailing {
                trailing(equalTo: view.trailingAnchor, constant: constant)
            }
            
            if constraint == .top {
                top(equalTo: view.topAnchor, constant: constant)
            }
            
            if constraint == .bottom {
                bottom(equalTo: view.bottomAnchor, constant: constant)
            }
            
            if constraint == .centerX {
                centerX(equalTo: view.centerXAnchor, constant: constant)
            }
            
            if constraint == .centerY {
                centerY(equalTo: view.centerYAnchor, constant: constant)
            }
        }
        
        return self
    }
    
    @discardableResult
    func center(equalTo view: UIView, constant: CGFloat = 0) -> UIView {
        setConstrainable()
        centerX(equalTo: view.centerXAnchor, constant: constant)
        centerY(equalTo: view.centerYAnchor, constant: constant)
        return self
    }
}


// MARK: - Wrapping

extension UIView {
    func inContainer() -> (contentView: UIView, containerView: UIView) {
        let containerView = UIView()
        containerView.addSubview(self)
        
        setConstrainable()
        containerView.setConstrainable()
        
        return (self, containerView)
    }
}
