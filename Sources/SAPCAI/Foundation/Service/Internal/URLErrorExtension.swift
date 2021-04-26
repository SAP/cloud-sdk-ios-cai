import Foundation

extension URLError {
    // swiftlint:disable cyclomatic_complexity
    static func lookForError(in response: URLResponse?) -> URLError? {
        guard let response = response as? HTTPURLResponse else { return nil }

        switch response.statusCode {
        case 200 ... 299:
            return nil
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbiddden
        case 404:
            return .notFound
        case 405:
            return .notAllowed
        case 500:
            return .server
        case 502:
            return .badGateway
        case 503:
            return .unavailable
        case 504 ... 599:
            return .server
        default:
            return nil
        }
    }
}

extension URLError {
    static let badRequest = URLError(URLError.Code(rawValue: 400))

    static let unauthorized = URLError(URLError.Code(rawValue: 401))

    static let forbiddden = URLError(URLError.Code(rawValue: 403))

    static let notFound = URLError(URLError.Code(rawValue: 404))

    static let notAllowed = URLError(URLError.Code(rawValue: 405))

    static let server = URLError(URLError.Code(rawValue: 500))

    static let badGateway = URLError(URLError.Code(rawValue: 502))

    static let unavailable = URLError(URLError.Code(rawValue: 503))
}
