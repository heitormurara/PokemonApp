@testable import onTopPoke

final class PaginationManagerMock: PaginationManaging {
    var didSetNextPage = false
    
    var nextPage: onTopPoke.Page? {
        didSet {
            didSetNextPage = true
        }
    }
    
    init(nextPage: onTopPoke.Page?) {
        self.nextPage = nextPage
    }
}
