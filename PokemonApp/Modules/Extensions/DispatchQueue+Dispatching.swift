import Foundation

extension DispatchQueue: Dispatching {
    func async(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}
