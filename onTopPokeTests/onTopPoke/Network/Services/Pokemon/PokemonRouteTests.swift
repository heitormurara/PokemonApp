import XCTest
@testable import onTopPoke

final class PokemonRouteTests: XCTestCase {
    func test_getSpecies() {
        let sut = PokeAPIRoute.getSpecies(Page(limit: 20, offset: 0))
        XCTAssertEqual(sut.baseURL, "https://pokeapi.co", "Invalid baseURL.")
        XCTAssertEqual(sut.path, "/api/v2/pokemon-species", "Invalid path.")
        XCTAssertEqual(sut.parameters?.count, 2, "getSpecies route should receive limit and offset parameters.")
        XCTAssertEqual(sut.method, .get, "getSpecies route should be a GET request.")
    }
    
    func test_getSpecie() {
        let sut = PokeAPIRoute.getSpecie(fromSpecieId: 1)
        XCTAssertEqual(sut.baseURL, "https://pokeapi.co", "Invalid baseURL.")
        XCTAssertEqual(sut.path, "/api/v2/pokemon-species/1", "Invalid path.")
        XCTAssertNil(sut.parameters, "getImage route shouldn't receive any parameters.")
        XCTAssertEqual(sut.method, .get, "getSpecies route should be a GET request.")
    }
    
    func test_getEvolutionChain() {
        let sut = PokeAPIRoute.getEvolutionChain(fromChainId: 1)
        XCTAssertEqual(sut.baseURL, "https://pokeapi.co", "Invalid baseURL.")
        XCTAssertEqual(sut.path, "/api/v2/evolution-chain/1", "Invalid path.")
        XCTAssertNil(sut.parameters, "getEvolutionChain route shouldn't receive any parameters.")
        XCTAssertEqual(sut.method, .get, "getEvolutionChain route should be a GET request.")
    }
}
