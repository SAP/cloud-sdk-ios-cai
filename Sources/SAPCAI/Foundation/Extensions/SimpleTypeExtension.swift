import Foundation

class CAIBundle {}

extension Bundle {
    static var cai: Bundle {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: CAIBundle.self)
        #endif
    }
}

// MARK: - String Extension

extension String {
    /// Return true if the string contains HTML tags
    var isHTML: Bool {
        !self.matches(for: "<[^>]+>.*</[^>]+>").isEmpty || !self.matches(for: "<br/?>").isEmpty
    }

    /// Removes whitespaces and new lines at the beginning and the end
    ///
    /// - Returns: String
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Checks if a string matches a regex pattern
    ///
    /// - Parameter regex: Regex to match
    /// - Returns: [String] Array of results
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch {
            dlog("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    /// Find and extract URL in a String
    ///
    /// - Returns: nil if not found or multiple. URL otherwise
    func extractURL() -> URL? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            
            if matches.count != 1 {
                return nil
            }
            let match = matches.first!
            
            guard let range = Range(match.range, in: self) else {
                return nil
            }
            
            let url = self[range]
            
            return URL(string: String(url))
        } catch {
            return nil
        }
    }
}

// MARK: - URL Extension

extension URL {
    /// Removes last '/' if exist
    ///
    /// - Returns: URL
    func dropLastSlash() -> URL {
        if absoluteString.hasSuffix("/") {
            var newStr = absoluteString
            newStr.removeLast()
            return URL(string: newStr)!
        } else {
            return self
        }
    }
    
    var isCustomURLScheme: Bool {
        if let re = try? NSRegularExpression(pattern: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", options: [.caseInsensitive]) {
            return re.matches(in: self.absoluteString, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: self.absoluteString.count)).isEmpty
        }
        return true
    }

    var isHTTPURL: Bool {
        !self.isCustomURLScheme
    }
}

extension Data {
    var toString: String {
        String(data: self, encoding: .utf8) ?? "invalid data"
    }
}

extension Array {
    /// Mutating function to allow modification of an Array content
    /// - Parameter body: Closure to implement the array modification on
    mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> Void) {
        for index in indices {
            self.modifyElement(atIndex: index) { body(index, &$0) }
        }
    }
    
    /// /// Mutating function to allow modification of an Array element
    /// - Parameter index: Index of element in the array
    /// - Parameter modifyElement: Closure to implement the array item changes on
    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> Void) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
}
