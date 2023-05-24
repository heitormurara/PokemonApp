import Foundation

final class JSONReader<T: Decodable> {
    func getFromFile(named: String) -> T {
        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: named, withExtension: "json") else {
            fatalError("Inexistent file URL")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Inexistent data")
        }
        
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Couldn't decode Data into \(T.self)")
        }
        
        return decoded
    }
}
