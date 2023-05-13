import Foundation

typealias DataResult = Result<Data, Error>

protocol NetworkServiceProviding {
    /// Uses the Provider's `URLSession` to make the `NetworkService` request, parse the result and completes.
    ///
    /// - Parameters:
    ///     - service: The `NetworkService` that contains the `URLRequest`
    ///     - completion: The completion handler to call when the data task is complete, either with a `Decodable` success or with a `Error` failure.
    func request<E: Decodable>(_ service: NetworkService, completion: @escaping (Result<E, Error>) -> Void)
    
    /// Uses the Provider's `URLSession` to make the `NetworkService` request and completes with either the data or the error.
    ///
    /// - Parameters:
    ///     - service: The `NetworkService` that contains the `URLRequest`
    ///     - completion: The completion handler to call when the data task is complete, either with the `Error` or with the response `Data`.
    func requestData(_ service: NetworkService, completion: @escaping (DataResult) -> Void)
}

final class NetworkServiceProvider {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}


// MARK: - NetworkServiceProviding

extension NetworkServiceProvider: NetworkServiceProviding {
    func request<E: Decodable>(_ service: NetworkService, completion: @escaping (Result<E, Error>) -> Void) {
        urlSession.dataTask(with: service.urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.emptyData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(E.self, from: data)
                completion(.success(decoded))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func requestData(_ service: NetworkService, completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: service.urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.emptyData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
