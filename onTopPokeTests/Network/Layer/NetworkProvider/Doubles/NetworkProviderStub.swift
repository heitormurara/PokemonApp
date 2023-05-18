import Foundation
@testable import onTopPoke

final class NetworkProviderStub: NetworkProviding {
    var requestDecodableSuccess: Decodable?
    var requestDecodableFailure: Error?
    
    var requestDataSuccess: Data?
    var requestDataFailure: Error?
    
    func request<T>(_ route: onTopPoke.NetworkRoute, decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        if let requestDecodableSuccess = requestDecodableSuccess as? T {
            return .success(requestDecodableSuccess)
        }
        
        if let requestDecodableFailure = requestDecodableFailure {
            return .failure(requestDecodableFailure)
        }
        
        return .failure(StubError.any)
    }
    
    func request(_ route: onTopPoke.NetworkRoute) async -> Result<Data, Error> {
        if let requestDataSuccess = requestDataSuccess {
            return .success(requestDataSuccess)
        }
        
        if let requestDataFailure = requestDataFailure {
            return .failure(requestDataFailure)
        }
        
        return .failure(StubError.any)
    }
}
