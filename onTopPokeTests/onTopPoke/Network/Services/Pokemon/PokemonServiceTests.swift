import XCTest
@testable import onTopPoke

final class PokemonServiceTests: XCTestCase {
    func test_getSpecies_requestsFromProvider() {
        let networkProviderMock = NetworkProviderMock()
        let sut = PokemonService(networkProvider: networkProviderMock)
        sut.getSpecies(page: Page(limit: 20, offset: 0)) { _ in }
        
        XCTAssertTrue(networkProviderMock.hasRequestedDecodable, "getSpecies should request from NetworkProvider.")
    }
    
    func test_getSpecies_completes() {
        let sut = PokemonService(networkProvider: NetworkProviderStub())
        let expectation = XCTestExpectation(description: "getSpecies should complete on NetworkProvider completion.")
        
        sut.getSpecies(page: Page(limit: 20, offset: 0)) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_getSpecie_requestsFromProvider() {
        let networkProviderMock = NetworkProviderMock()
        let sut = PokemonService(networkProvider: networkProviderMock)
        sut.getSpecie(fromSpecieId: 1) { _ in }
        
        XCTAssertTrue(networkProviderMock.hasRequestedDecodable, "getSpecie should request from NetworkProvider.")
    }
    
    func test_getSpecie_completes() {
        let sut = PokemonService(networkProvider: NetworkProviderStub())
        let expectation = XCTestExpectation(description: "getSpecie should complete on NetworkProvider completion.")
        
        sut.getSpecie(fromSpecieId: 1) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_getEvolutionChain_requestsFromProvider() {
        let networkProviderMock = NetworkProviderMock()
        let sut = PokemonService(networkProvider: networkProviderMock)
        sut.getEvolutionChain(fromChainId: 1) { _ in }
        
        XCTAssertTrue(networkProviderMock.hasRequestedDecodable, "getEvolutionChain should request from NetworkProvider.")
    }
    
    func test_getEvolutionChain_completes() {
        let sut = PokemonService(networkProvider: NetworkProviderStub())
        let expectation = XCTestExpectation(description: "getEvolutionChain should complete on NetworkProvider completion.")
        
        sut.getEvolutionChain(fromChainId: 1) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
