import Foundation

protocol DispatchingGroup {
    func notify(queue: DispatchQueue,
                _ work: @escaping () -> Void)
}

extension DispatchGroup: DispatchingGroup {
    func notify(queue: DispatchQueue, _ work: @escaping () -> Void) {
        self.notify(queue: queue, execute: work)
    }
}
