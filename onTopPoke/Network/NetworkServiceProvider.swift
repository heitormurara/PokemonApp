import Foundation

protocol NetworkServiceProviding {
    associatedtype Service: NetworkService
    
    func request<E: Decodable>(_ service: Service, completion: @escaping (Result<E, Error>) -> Void)
}

final class NetworkServiceProvider<Service: NetworkService>: NetworkServiceProviding {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Uses the Provider's `URLSession` to make the `NetworkService` request, parse the result and completes.
    ///
    /// - Parameters:
    ///     - service: The `NetworkService` that contains the `URLRequest`
    ///     - completion: The completion handler to call when the data task is complete, either with a `Decodable` success or with a `Error` failure.
    func request<E: Decodable>(_ service: Service, completion: @escaping (Result<E, Error>) -> Void) {
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
            } catch (let error) {
                completion(.failure(NetworkServiceError.decodingFailure))
            }
        }.resume()
    }
}
