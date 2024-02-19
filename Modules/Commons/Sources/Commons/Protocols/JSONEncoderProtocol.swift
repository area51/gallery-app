import Foundation

/// A protocol to abstract the JSONEncoder
public protocol JSONEncoderProtocol {
    /// Encode a value to a Data object
    /// - parameter value: The value to encode
    /// - returns: The encoded data
    /// - throws: An error if any value throws an error during encoding.
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

/// Conformance for JSONEncoder
extension JSONEncoder: JSONEncoderProtocol {}
