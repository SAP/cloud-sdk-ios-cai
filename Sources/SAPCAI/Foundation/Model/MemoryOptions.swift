import Foundation

/**
 Context information for the bot
 */
public struct MemoryOptions {
    /// indicator if `memory` content, once sent to CAI, shall be added to the current state of the memory or if the content shall replace the current memory
    public var merge: Bool
    /// freely defined payload which needs to be encodable. Example of an encoded object: { "firstName": "John", "lastName":"Doe" }
    public var memory: Encodable

    /// Initializer
    /// - Parameters:
    ///   - merge: indicator if `memory` content, once sent to CAI, shall be added to the current state of the memory or if the content shall replace the current memory
    ///   - memory: freely defined payload which needs to be encodable. Example of an encoded object: { "firstName": "John", "lastName":"Doe" }
    public init(merge: Bool, memory: Encodable) {
        self.merge = merge
        self.memory = memory
    }
}
