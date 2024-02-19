import Foundation
import Commons

public struct JSONDecoderFactory {
    /// Creates the default instance of JSONDecoderProtocol
    static public func makeDefault() -> JSONDecoderProtocol {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
