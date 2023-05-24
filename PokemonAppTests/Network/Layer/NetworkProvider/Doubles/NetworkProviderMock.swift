import Foundation
@testable import onTopPoke

final class NetworkProviderMock: NetworkProviding {
    var calledRequestDecodable = false
    var calledRequestData = false
    
    func request<T>(_ route: onTopPoke.NetworkRoute, decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        calledRequestDecodable = true
        return .failure(StubError.any)
    }
    
    func request(_ route: onTopPoke.NetworkRoute) async -> Result<Data, Error> {
        calledRequestData = true
        return .failure(StubError.any)
    }
}
