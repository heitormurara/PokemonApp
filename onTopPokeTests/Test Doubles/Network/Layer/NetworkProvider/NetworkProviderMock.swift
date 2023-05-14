@testable import onTopPoke

final class NetworkProviderMock: NetworkProviding {
    var hasRequestedDecodable = false
    var hasRequestedData = false
    
    var requestDecodableCount = 0
    var requestDataCount = 0
    
    func request<T>(_ service: onTopPoke.NetworkRoute, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        hasRequestedDecodable = true
        requestDecodableCount += 1
    }
    
    func requestData(_ service: onTopPoke.NetworkRoute, completion: @escaping (onTopPoke.DataResult) -> Void) {
        hasRequestedData = true
        requestDataCount += 1
    }
}
