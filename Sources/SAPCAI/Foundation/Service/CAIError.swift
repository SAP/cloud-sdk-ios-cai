import Foundation
import SAPCommon

/// Enum CAIError. Implement SAPError.
/// Raised when something is wrong with our platform services.
public struct CAIError: SAPError, Equatable {
    enum ErrorType {
        case server
        case cancelled
        case dataDecoding
        case conversationNotFound
    }
    
    /// Server error
    public static func server(_ error: Error? = nil, reason: String? = nil) -> CAIError {
        CAIError(type: .server, error: error, reason: reason)
    }
    
    public static var cancelled: CAIError {
        CAIError(type: .cancelled)
    }

    public static func dataDecoding(_ error: Error? = nil, reason: String? = nil) -> CAIError {
        CAIError(type: .dataDecoding, error: error, reason: reason)
    }
    
    /// Conversation not found error
    public static func conversationNotFound(_ error: Error? = nil, reason: String? = nil) -> CAIError {
        CAIError(type: .conversationNotFound, error: error, reason: reason)
    }

    private init(type: ErrorType, error: Error? = nil, reason: String? = nil) {
        self.type = type
        self.internalError = error
        self.failureReason = reason
    }
    
    internal var type: ErrorType
    
    private var internalError: Error?
    
    public var failureReason: String?
    
    // Localized
    public var description: String {
        switch self.type {
        case .server:
            return NSLocalizedString("error.server", tableName: "Localizable", bundle: Bundle.cai, comment: "")
        case .cancelled:
            return NSLocalizedString("error.RequestCancelled", tableName: "Localizable", bundle: Bundle.cai, comment: "")
        case .dataDecoding:
            return NSLocalizedString("error.JSONParserError", tableName: "Localizable", bundle: Bundle.cai, comment: "")
        case .conversationNotFound:
            return NSLocalizedString("error.conversationNotFound", tableName: "Localizable", bundle: Bundle.cai, comment: "")
        }
    }
    
    // Not localized, for debugging purposes
    public var debugDescription: String {
        switch self.type {
        case .server:
            return "An internal server error occurred. Error: \(String(describing: self.internalError)). Reason: \(String(describing: self.failureReason))"
        case .cancelled:
            return "The operation has been cancelled"
        case .dataDecoding:
            return "Decoding error occurred. Error: \(String(describing: self.internalError)). Reason: \(String(describing: self.failureReason))"
        case .conversationNotFound:
            return "Conversation not found error occurred. Error: \(String(describing: self.internalError)). Reason: \(String(describing: self.failureReason))"
        }
    }
    
    // Localized
    public var errorDescription: String? {
        self.description
    }
    
    public static func == (lhs: CAIError, rhs: CAIError) -> Bool {
        lhs.type == rhs.type
    }
}
