import Foundation

extension DispatchGroup: DispatchingGroup {
    func notify(on queue: DispatchQueue, execute work: @escaping () -> Void) {
        self.notify(queue: queue, execute: work)
    }
}
