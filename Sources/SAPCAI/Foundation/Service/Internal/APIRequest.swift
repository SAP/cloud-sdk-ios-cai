import Foundation

protocol APIRequest {
    var method: String { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var headers: [String: String] { get }
    var httpBody: Data? { get }
}

extension APIRequest {
    func urlRequest(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(self.path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        for (key, val) in self.headers {
            request.addValue(val, forHTTPHeaderField: key)
        }
        request.httpBody = self.httpBody
        return request
    }
}
