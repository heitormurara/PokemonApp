@testable import onTopPoke

final class LoadManagerStub: LoadManaging {
    var isLoading: Bool
    
    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func startLoading() {}
    
    func stopLoading() {}
}
