import XCTest
@testable import onTopPoke

final class PokemonRouteTests: XCTestCase {
    func test_getSpecies() {
        let sut = PokemonRoute.getSpecies(Page(limit: 20, offset: 0))
        XCTAssertEqual(sut.baseURL, "https://pokeapi.co", "Invalid baseURL.")
        XCTAssertEqual(sut.path, "/api/v2/pokemon-species", "Invalid path.")
        XCTAssertEqual(sut.parameters?.count, 2, "getSpecies route should receive limit and offset parameters.")
        XCTAssertEqual(sut.method, .get, "getSpecies route should be a GET request.")
    }
}
