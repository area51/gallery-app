import Foundation
import ArticClient

public struct RepositoryFactory {
    static public func make() -> RepositoryProtocol {
        Repository(
            artwork: makeArtworkRepository(),
            artist: makeArtistRepository()
        )
    }
    
    static private func makeArtistRepository() -> ArtistRepositoryProtocol {
        ArtistRepository(
            apiClient: ArticClientFactory.make(),
            cacheManager: CacheManagerFactory.make()
        )
    }
    
    static private func makeArtworkRepository() -> ArtworkRepositoryProtocol {
        ArtworkRepository(
            apiClient: ArticClientFactory.make(),
            cacheManager: CacheManagerFactory.make()
        )
    }
}
