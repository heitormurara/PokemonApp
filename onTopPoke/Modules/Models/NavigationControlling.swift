import UIKit

protocol NavigationControlling: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

extension UINavigationController: NavigationControlling {}
