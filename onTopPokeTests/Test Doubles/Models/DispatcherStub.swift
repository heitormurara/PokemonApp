@testable import onTopPoke

final class DispatcherStub: Dispatching {
    func async(_ work: @escaping () -> Void) {
        work()
    }
}
