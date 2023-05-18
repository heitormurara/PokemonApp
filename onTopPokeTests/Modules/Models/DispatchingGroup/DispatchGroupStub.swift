import Foundation
@testable import onTopPoke

final class DispatchGroupStub: DispatchingGroup {
    func enter() {}
    
    func leave() {}
    
    func notify(on queue: DispatchQueue, execute work: @escaping () -> Void) {
        work()
    }
}
