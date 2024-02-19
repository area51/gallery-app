import Foundation
import Commons

public struct CacheManager: CacheManagerProtocol, Loggable {
    public let cache: CacheProtocol
    
    public init(cache: CacheProtocol) {
        self.cache = cache
    }
    
    public let encoder: JSONEncoderProtocol = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    public let decoder: JSONDecoderProtocol = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public func loadObject<T: Codable>(_ key: String) throws -> T? {
        let typeId = String(describing: T.self)
        log("type: \(typeId)")
        guard let cachedData = cache.get(key) else {
            return nil
        }
        do {
            let data: T = try decoder.decode(T.self, from: cachedData)
            log("Success recovering: \(typeId)")
            return data
        } catch {
            log("Error decoding \(typeId) from cache. Error: \(error)")
            log("Corrupted cached data: \(String(data: cachedData, encoding: .utf8) ?? "Empty")")
            log("Removing from cache and falling back to network")
            cache.remove(key)
            return nil
        }
    }
    
    public func storeObject<T: Codable>(_ obj: T, key: String) async -> T? {
        let typeId = String(describing: T.self)
        do {
            let data: Data = try encoder.encode(obj)
            // If data is encoded successfully, save it to cache
            cache.set(key, data)
            // And return the original value
            return obj
        } catch {
            log("Error encoding \(typeId) for cache. Error: \(error)")
            log("Corrupted data: \(String(describing: obj))")
            log("Returning network result without caching")
            return obj
        }
    }
}
