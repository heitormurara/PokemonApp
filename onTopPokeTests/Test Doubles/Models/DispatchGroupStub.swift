import Foundation
@testable import onTopPoke

final class DispatchGroupStub: DispatchingGroup {
    func notify(queue: DispatchQueue, _ work: @escaping () -> Void) {
        work()
    }
}
