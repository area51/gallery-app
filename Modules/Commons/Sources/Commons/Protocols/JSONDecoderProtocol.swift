import Foundation

/// A protocol to abstract the JSONDecoderProtocol
public protocol JSONDecoderProtocol {
    /// Decodes a top-level value of the given type from the given JSON representation.
    /// - parameter type: The type of the value to decode
    /// - parameter data: The data to decode from
    /// - returns: The decoded value
    /// - throws: An error if any value throws an error during decoding.
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

/// Conformance for JSONDecoder
extension JSONDecoder: JSONDecoderProtocol {}
