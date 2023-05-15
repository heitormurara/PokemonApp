@testable import onTopPoke

final class LoadManagerMock: LoadManaging {
    var didSetIsLoading = false
    var didStartLoading = false
    var didStopLoading = false
    
    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    var isLoading: Bool {
        didSet {
            didSetIsLoading = true
        }
    }
    
    func startLoading() {
        didStartLoading = true
    }
    
    func stopLoading() {
        didStopLoading = true
    }
}
