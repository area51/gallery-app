import Foundation
import Commons

public protocol CacheManagerProtocol {
    var cache: CacheProtocol { get }
    var decoder: JSONDecoderProtocol { get }
    var encoder: JSONEncoderProtocol { get }
    func loadObject<T: Codable>(_ key: String) throws -> T?
    func storeObject<T: Codable>(_ obj: T, key: String) async -> T?
}
