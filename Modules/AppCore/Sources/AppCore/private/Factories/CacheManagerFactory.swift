import Foundation

public struct CacheManagerFactory {
    static func make() -> CacheManagerProtocol {
        CacheManager(cache: AppCache.shared)
    }
}
