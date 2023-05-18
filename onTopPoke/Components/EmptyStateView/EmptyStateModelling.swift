import UIKit

protocol EmptyStateModelling {
    var image: UIImage { get }
    var text: String { get }
    var actionTitle: String { get }
    var actionHandler: (() async -> Void) { get }
}

// MARK: - Models

struct GenericUnknownEmptyStateModel: EmptyStateModelling {
    var image: UIImage = UIImage(systemName: "exclamationmark.triangle")!
    var text: String = "Something went wrong."
    var actionTitle: String = "Try again"
    
    var actionHandler: (() async -> Void)
}
