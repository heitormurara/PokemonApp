@testable import onTopPoke

final class PaginationManagerMock: PaginationManaging {
    var didSetNextPage = false
    var didSetIsLoading = false
    
    var nextPage: onTopPoke.Page? {
        didSet {
            didSetNextPage = true
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            didSetIsLoading = true
        }
    }
    
    init(nextPage: onTopPoke.Page?, isLoading: Bool) {
        self.nextPage = nextPage
        self.isLoading = isLoading
    }
}
