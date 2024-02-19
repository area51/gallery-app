import Foundation
import Commons
import AppCore

class CacheManagerMock: CacheManagerProtocol {
    var loadCalled: Bool = false
    var storeCalled: Bool = false
    var loadCalledWithKey: String?
    var storeCalledWithKey: String?
    
    var cache: CacheProtocol
    var decoder: JSONDecoderProtocol
    var encoder: JSONEncoderProtocol

    init(
        cache: CacheProtocol,
        decoder: JSONDecoderProtocol = JSONDecoder(),
        encoder: JSONEncoderProtocol = JSONEncoder()
    ) {
        self.cache = cache
        self.decoder = decoder
        self.encoder = encoder
    }

    func loadObject<T: Codable>(_ key: String) throws -> T? {
        loadCalled = true
        loadCalledWithKey = key
        if let data = cache.get(key) {
            return try decoder.decode(T.self, from: data)
        }
        return nil
    }

    func storeObject<T: Codable>(_ obj: T, key: String) async -> T? {
        storeCalled = true
        storeCalledWithKey = key
        if let data = try? encoder.encode(obj) {
            cache.set(key, data)
        }
        return obj
    }
}
