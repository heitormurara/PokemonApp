import Foundation

extension String {
    init(_ localizedString: LocalizedString) {
        self = NSLocalizedString(localizedString.rawValue, comment: "")
    }
}
