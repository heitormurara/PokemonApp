import Foundation

typealias DataResult = Result<Data, Error>

enum NetworkProviderError: Error {
    case emptyData
    case emptyURLRequest
    case emptyResponse
    case decodingError
    case unauthorized
    case unexpedtedStatusCode
    case unknown
}

protocol NetworkProviding {
    func request<T>(_ route: NetworkRoute,
                    decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable
    func request(_ route: NetworkRoute) async -> Result<Data, Error>
}

final class NetworkProvider {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}


// MARK: - NetworkServiceProviding

extension NetworkProvider: NetworkProviding {
    func request<T>(_ route: NetworkRoute,
                    decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        guard case let .success(data) = await request(route) else {
            return .failure(NetworkProviderError.unknown)
        }
        
        do {
            let decodable = try JSONDecoder().decode(modelType, from: data)
            return .success(decodable)
        } catch {
            return .failure(NetworkProviderError.decodingError)
        }
    }
    
    func request(_ route: NetworkRoute) async -> Result<Data, Error> {
        guard let urlRequest = route.urlRequest else {
            return .failure(NetworkProviderError.emptyURLRequest)
        }
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(NetworkProviderError.emptyResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 401:
                return .failure(NetworkProviderError.unauthorized)
            default:
                return .failure(NetworkProviderError.unexpedtedStatusCode)
            }
        } catch {
            return .failure(NetworkProviderError.unknown)
        }
    }
}
