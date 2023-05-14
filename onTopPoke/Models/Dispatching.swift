import Foundation

protocol Dispatching {
    func async(_ work: @escaping () -> Void)
}

extension DispatchQueue: Dispatching {
    func async(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}
