import Foundation

protocol DispatchingGroup {
    func enter()
    func leave()
    func notify(on queue: DispatchQueue,
                execute work: @escaping () -> Void)
}

extension DispatchGroup: DispatchingGroup {
    func notify(on queue: DispatchQueue, execute work: @escaping () -> Void) {
        self.notify(queue: queue, execute: work)
    }
}
