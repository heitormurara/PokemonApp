import XCTest
@testable import onTopPoke

final class PokeAPIServiceTests: XCTestCase {
    func test_getImages_onProviderSuccess_completesWithUpdatesSpecies() {
        let sut = PokeAPIService(networkProvider: NetworkProviderStub(),
                                 dispatchGroup: DispatchGroupStub())
        
        let species: PokemonListItemList = JSONReader().getFromFile(named: "pokemonListItemList")
        var updatedSpecies: PokemonListItemList?
        
        let expectation = XCTestExpectation(description: "")
        
        sut.getImages(for: species) { species in
            updatedSpecies = species
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotEqual(species.first?.image, updatedSpecies?.first?.image, "getImages should complete with the updated species objects.")
    }
    
    func test_getImage_requestsFromProvider() {
        let networkProviderMock = NetworkProviderMock()
        let sut = PokeAPIService(networkProvider: networkProviderMock,
                                 dispatchGroup: DispatchGroupStub())
        sut.getImage(fromSpecieId: 1) { _ in }
        
        XCTAssertTrue(networkProviderMock.hasRequestedData, "getImage should request from NetworkProvider.")
    }
    
    func test_getImage_completes() {
        let sut = PokeAPIService(networkProvider: NetworkProviderStub(),
                                 dispatchGroup: DispatchGroupStub())
        let expectation = XCTestExpectation(description: "getImage should complete on NetworkProvider completion.")
        
        sut.getImage(fromSpecieId: 1) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
