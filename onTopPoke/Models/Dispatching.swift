import Foundation

protocol Dispatching {
    func async(_ work: @escaping () -> Void)
}

extension DispatchQueue: Dispatching {
    func async(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}

protocol DispatchingGroup {
    func notify(queue: DispatchQueue,
                _ work: @escaping () -> Void)
}

extension DispatchGroup: DispatchingGroup {
    func notify(queue: DispatchQueue, _ work: @escaping () -> Void) {
        self.notify(queue: queue, execute: work)
    }
}
