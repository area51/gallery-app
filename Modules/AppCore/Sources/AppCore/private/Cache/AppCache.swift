import Foundation
import Commons
import Cache

public final class AppCache: CacheProtocol, Loggable {
    static public let shared = AppCache()
    private let cache: Storage<String, Data>?
    
    private init() {
        let diskConfig = DiskConfig(name: "AppCache")
        let totalCostLimit: UInt = 50 * 1024 * 1024 // 50MB
        let memoryConfig = MemoryConfig(
            expiry: .seconds(60 * 60 * 24 * 7), // 1 week
            totalCostLimit: totalCostLimit
        )

        self.cache = try? Storage<String, Data>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }
    
    public func set(_ key: String, _ data: Data) {
        cache?.async.setObject(data, forKey: key) { [weak self] result in
          switch result {
            case .success:
              self?.log("Saved data for key: (\(key))")
            case .failure(let error):
              self?.log("Error saving data for key: (\(key)). Error: \(error)")
          }
        }
    }
    
    public func get(_ key: String) -> Data? {
        do {
            let data = try cache?.object(forKey: key)
            log("Cache hit for key: (\(key)).")
            return data
        } catch {
            log("Cache miss for key: (\(key)).")
            return nil
        }
    }
    
    public func remove(_ key: String) {
        cache?.async.removeObject(forKey: key) { [weak self] result in
          switch result {
            case .success:
              self?.log("Removed data for key: (\(key)).")
            case .failure(let error):
              self?.log("Error removing data for key: (\(key)). Error: \(error)")
          }
        }
    }
    
    public func reset() {
        cache?.async.removeAll(completion: { [weak self] result in
          switch result {
            case .success:
              self?.log("Cache reseted successfully.")
            case .failure(let error):
              self?.log("Error resetting cache. Error: \(error)")
          }
        })
    }
}
