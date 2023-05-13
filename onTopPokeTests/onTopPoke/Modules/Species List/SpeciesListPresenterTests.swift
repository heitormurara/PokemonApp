import XCTest
@testable import onTopPoke

final class SpeciesListPresenterTests: XCTestCase {
    override func setUp() {}
    
    override func tearDown() {}
    
    func test_getSpecies_whenLoading_doesntRequestFromProvider() {
        let mockProvider = NetworkServiceProviderMock()
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       provider: mockProvider)
        sut.getSpecies()
        sut.getSpecies()

        XCTAssertEqual(mockProvider.requestDecodableCount, 1, "`getSpecies` shouldn't request new Species from provider if isn't loading.")
    }
    
    func test_getSpecies_whenNotLoading_requestsFromProvider() {
        let mockProvider = NetworkServiceProviderMock()
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       provider: mockProvider)
        sut.getSpecies()
        
        XCTAssertTrue(mockProvider.hasRequestedDecodable, "`getSpecies` should request new Species from provider if isn't loading.")
    }
    
    func test_getSpecies_whenReachLastPage_doesntRequestFromProvider() {}
}

struct DispatchQueueStub: Dispatching {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
