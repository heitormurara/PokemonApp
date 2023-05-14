import UIKit
@testable import onTopPoke

final class NetworkProviderStub: NetworkProviding {
    var requestDataResult: DataResult = .success(Data())
    
    func request<T>(_ service: onTopPoke.NetworkRoute,
                    completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        completion(.failure(NetworkProviderError.emptyData))
    }
    
    func requestData(_ service: onTopPoke.NetworkRoute,
                     completion: @escaping (onTopPoke.DataResult) -> Void) {
        let image = UIImage(systemName: "star")
        if let data = image?.pngData() {
            completion(.success(data))
        } else {
            completion(requestDataResult)
        }
    }
}
