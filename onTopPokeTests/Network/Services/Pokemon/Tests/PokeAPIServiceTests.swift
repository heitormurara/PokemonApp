import XCTest
@testable import onTopPoke

final class PokeAPIServiceTests: XCTestCase {
    var networkProvider: NetworkProviding?
    var sut: PokeAPIServicing?
    
    override func setUp() {
        let networkProvider = NetworkProviderStub()
        self.networkProvider = networkProvider
        
        sut = PokeAPIService(networkProvider: networkProvider)
    }
    
    override func tearDown() {
        networkProvider = nil
        sut = nil
    }
    
    func test_getSpecies_onNetworkSuccess() async throws {
        let networkProviderStub = try XCTUnwrap(networkProvider as? NetworkProviderStub)
        let fileName = "speciePaginatedResult-single"
        let expectedDecodable: Paginated<Specie> = JSONReader().getFromFile(named: fileName)
        networkProviderStub.requestDecodableSuccess = expectedDecodable
        let expectedData = UIImage(systemName: "person")?.pngData()
        networkProviderStub.requestDataSuccess = expectedData
        
        let result = await sut?.getSpecies(at: Page(limit: 20, offset: 0))
        guard case let .success(paginated) = result else {
            XCTFail("Service should return a Decodable `Paginated<Specie>` on Provider success.")
            return
        }
        
        XCTAssertEqual(paginated.nextPage, Page(limit: 20, offset: 20), "Returned Page should match the expected `Page`.")
        XCTAssertEqual(paginated.array.first?.id, expectedDecodable.array.first?.id, "Returned Array should match the expected Array.")
        XCTAssertNotEqual(expectedDecodable.array.first?.image?.pngData(), expectedData, "Returned item Image Data should match `expectedData`.")
    }
    
    func test_getSpecies_onNetworkFailure() async throws {
        let networkProviderStub = try XCTUnwrap(networkProvider as? NetworkProviderStub)
        networkProviderStub.requestDecodableFailure = StubError.custom
        
        let result = await sut?.getSpecies(at: Page(limit: 20, offset: 0))
        guard case let .failure(error) = result else {
            XCTFail("Service should return an Error on Provider failure.")
            return
        }
        
        XCTAssertEqual(error as? StubError, StubError.custom, "Returned Error should match the expected `StubError.custom`")
    }
}
