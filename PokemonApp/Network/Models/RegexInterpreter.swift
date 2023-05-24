import Foundation

struct RegexInterpreter {
    static func idFromURL(_ urlString: String) -> Int? {
        let range = NSRange(location: 0, length: urlString.utf16.count)
        let regex = try? NSRegularExpression(pattern: "\\/(\\d+)\\/$")
        
        guard let match = regex?.firstMatch(in: urlString, range: range),
              let matchRange = Range(match.range(at: 1), in: urlString),
              let intValue = Int(urlString[matchRange]) else { return nil }
        
        return intValue
    }
}
