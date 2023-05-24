import XCTest
@testable import onTopPoke

final class PokeAPIRouteTests: XCTestCase {
    var sut: NetworkRoute?
    
    func test_getSpecies() {
        sut = PokeAPIRoute.getSpecies(page: Page(limit: 20, offset: 0))
        
        XCTAssertEqual(sut?.baseURL, "https://pokeapi.co")
        XCTAssertEqual(sut?.path, "/api/v2/pokemon-species")
        XCTAssertEqual(sut?.parameters, ["limit": String(20), "offset": String(0)])
        XCTAssertEqual(sut?.method, .get)
    }
    
    func test_getSpecie() {
        sut = PokeAPIRoute.getSpecie(specieID: 1)
        
        XCTAssertEqual(sut?.baseURL, "https://pokeapi.co")
        XCTAssertEqual(sut?.path, "/api/v2/pokemon-species/1")
        XCTAssertEqual(sut?.parameters, nil)
        XCTAssertEqual(sut?.method, .get)
    }
    
    func test_getEvolutionChain() {
        sut = PokeAPIRoute.getEvolutionChain(chainID: 1)
        
        XCTAssertEqual(sut?.baseURL, "https://pokeapi.co")
        XCTAssertEqual(sut?.path, "/api/v2/evolution-chain/1")
        XCTAssertEqual(sut?.parameters, nil)
        XCTAssertEqual(sut?.method, .get)
    }
    
    func test_getImage() {
        sut = PokeAPIRoute.getImage(specieID: 1)
        
        XCTAssertEqual(sut?.baseURL, "https://raw.githubusercontent.com")
        XCTAssertEqual(sut?.path, "/PokeAPI/sprites/master/sprites/pokemon/1.png")
        XCTAssertEqual(sut?.parameters, nil)
        XCTAssertEqual(sut?.method, .get)
    }
}
