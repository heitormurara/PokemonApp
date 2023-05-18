import UIKit

struct EmptyStateModel {
    let image: UIImage
    let text: String
    let actionTitle: String
    let actionHandler: (() async -> Void)
}
