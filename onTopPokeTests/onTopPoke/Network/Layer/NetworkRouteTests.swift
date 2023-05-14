import XCTest
@testable import onTopPoke

final class NetworkRouteStub: NetworkRoute {
    var baseURL: String = ""
    var path: String = ""
    var parameters: [String : String]? = nil
    var method: onTopPoke.HTTPMethod = .get
}

final class NetworkRouteTests: XCTestCase {
    var sut: NetworkRouteStub?
    
    override func setUp() {
        sut = NetworkRouteStub()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_url_withBaseURL_withPath_returnsNotNil() {
        sut?.baseURL = "https://www.google.com"
        sut?.path = "/imghp"
        XCTAssertNotNil(sut?.url, "url shouldn't be nil when NetworkRoute has a valid baseURL and path.")
    }
    
    func test_url_withEmptyBaseURL_returnsNotNil() {
        sut?.path = "/imghp"
        XCTAssertNil(sut?.url, "url should be nil when baseURL is empty.")
    }
    
    func test_url_withEmptyPath_returnsNotNil() {
        sut?.baseURL = "https://www.google.com"
        XCTAssertNil(sut?.url, "url should be nil when path is empty.")
    }
    
    func test_url_withEmptyBaseURL_withEmptyPath_returnsNil() {
        XCTAssertNil(sut?.url, "url should be nil when baseURL and path are empty.")
    }
    
    func test_url_getWithParameters_addsAsQueryItems() throws {
        sut?.baseURL = "https://www.google.com"
        sut?.path = "/imghp"
        sut?.parameters = ["limit": "20"]
        
        let url: URL = try XCTUnwrap(sut?.url, "url shouldn't be nil.")
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        XCTAssertNotNil(urlComponents?.queryItems)
    }
    
    func test_urlRequest_withInvalidURL_returnsNil() {
        XCTAssertNil(sut?.urlRequest, "urlRequest should be nil when URL is empty.")
    }
    
    func test_urlRequest_withValidURL_returnsNotNil() {
        sut?.baseURL = "https://www.google.com"
        sut?.path = "/imghp"
        XCTAssertNotNil(sut?.urlRequest, "urlRequest shouldn't be nil when URL is valid.")
    }
}
