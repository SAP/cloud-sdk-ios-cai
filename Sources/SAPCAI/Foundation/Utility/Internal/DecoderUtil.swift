import Foundation

struct DecoderUtil {
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        // date decoding strategy used to parse JSON timestamps into Date objects
        enum DateError: String, Error {
            case invalidDate
        }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var jsonDateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw DateError.invalidDate
        }
        decoder.dateDecodingStrategy = jsonDateDecodingStrategy
        return decoder
    }()
}
