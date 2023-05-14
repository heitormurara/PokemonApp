import XCTest
@testable import onTopPoke

final class PokeAPIRouteTests: XCTestCase {
    func test_getImage() {
        let sut = PokeAPIRoute.getImage(fromSpecieId: 1)
        XCTAssertEqual(sut.baseURL, "https://raw.githubusercontent.com", "Invalid baseURL.")
        XCTAssertEqual(sut.path, "/PokeAPI/sprites/master/sprites/pokemon/1.png", "Invalid path.")
        XCTAssertNil(sut.parameters, "getImage route shouldn't receive any parameters.")
        XCTAssertEqual(sut.method, .get, "getImage route should be a GET request.")
    }
}
