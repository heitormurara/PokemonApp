import Foundation
@testable import onTopPoke

struct DecodableRouteResult {
    let route: NetworkRoute
    let result: Result<Decodable, Error>
}

struct DataRouteResult {
    let route: NetworkRoute
    let result: Result<Data, Error>
}

final class NetworkProviderStub: NetworkProviding {
    private var decodableRouteResults: [DecodableRouteResult] = []
    private var dataRouteResults: [DataRouteResult] = []
    
    func request<T>(_ route: NetworkRoute,
                    decodeInto modelType: T.Type) async -> Result<T, Error> where T : Decodable {
        for routeResult in decodableRouteResults {
            guard routeResult.route.urlRequest == route.urlRequest else { continue }

            if case let .success(decodable) = routeResult.result, let success = decodable as? T {
                return .success(success)
            }

            if case let .failure(error) = routeResult.result {
                return .failure(error)
            }
        }
        
        return .failure(StubError.any)
    }
    
    func request(_ route: NetworkRoute) async -> Result<Data, Error> {
        for routeResult in dataRouteResults {
            guard routeResult.route.urlRequest == route.urlRequest else { continue }
            
            switch routeResult.result {
            case let .success(data):
                return .success(data)
            case let .failure(error):
                return .failure(error)
            }
        }
        
        return .failure(StubError.any)
    }
    
    func append(_ decodableRouteResult: DecodableRouteResult) {
        decodableRouteResults.append(decodableRouteResult)
    }
    
    func append(_ dataRouteResult: DataRouteResult) {
        dataRouteResults.append(dataRouteResult)
    }
}
