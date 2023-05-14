import Foundation

typealias DataResult = Result<Data, Error>

enum NetworkProviderError: Error {
    case emptyData
    case emptyURLRequest
}

protocol NetworkProviding {
    func request<T: Decodable>(_ service: NetworkRoute, completion: @escaping (Result<T, Error>) -> Void)
    func requestData(_ service: NetworkRoute, completion: @escaping (DataResult) -> Void)
}

final class NetworkProvider {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}


// MARK: - NetworkServiceProviding

extension NetworkProvider: NetworkProviding {
    func request<T: Decodable>(_ service: NetworkRoute,
                               completion: @escaping (Result<T, Error>) -> Void) {
        self.requestData(service) { result in
            switch result {
            case let .success(data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func requestData(_ service: NetworkRoute,
                     completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = service.urlRequest else {
            completion(.failure(NetworkProviderError.emptyURLRequest))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkProviderError.emptyData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
