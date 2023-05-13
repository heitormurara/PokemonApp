@testable import onTopPoke

final class NetworkServiceProviderMock: NetworkServiceProviding {
    var hasRequestedDecodable = false
    var hasRequestedData = false
    
    var requestDecodableCount = 0
    var requestDataCount = 0
    
    func request<E>(_ service: onTopPoke.NetworkService, completion: @escaping (Result<E, Error>) -> Void) where E : Decodable {
        hasRequestedDecodable = true
        requestDecodableCount += 1
    }
    
    func requestData(_ service: onTopPoke.NetworkService, completion: @escaping (onTopPoke.DataResult) -> Void) {
        hasRequestedData = true
        requestDataCount += 1
    }
}
