@testable import onTopPoke

final class LoadManagerMock: LoadManaging {
    var didSetIsLoading = false
    
    var isLoading: Bool {
        didSet {
            didSetIsLoading = true
        }
    }
    
    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
