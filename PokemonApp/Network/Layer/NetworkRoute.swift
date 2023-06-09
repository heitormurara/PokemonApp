import Foundation

/// The protocol used to define the specifications needed for a `NetworkServiceProvider`
protocol NetworkRoute {
    /// The base `URL` for the Service
    var baseURL: String { get }
    
    /// The path to be appended to the `baseURL` to form the full `URL`
    var path: String { get }
    
    /// The parameters to be added as `URLQueryItem`s
    var parameters: [String: String]? { get }
    
    /// The HTTP method used in the request
    var method: HTTPMethod { get }
}

extension NetworkRoute {
    /// Complete `URL` with `baseURL`, `path` and `parameters` (if existent)
    var url: URL? {
        if baseURL.isEmpty || path.isEmpty { return nil }
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        if method == .get, let parameters = parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents?.url
    }
    
    /// The `URLRequest` for the Service
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

