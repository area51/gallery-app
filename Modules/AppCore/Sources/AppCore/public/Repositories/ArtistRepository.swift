import Foundation
import Commons
import ArticClient

final public class ArtistRepository: ArtistRepositoryProtocol, Loggable {
    private let apiClient: ArticClientProtocol
    private let cacheManager: CacheManagerProtocol?
    
    /// Initializes the repository for artists.
    /// - parameter apiClient: The client used to fetch the data.
    /// - parameter cacheManager: The cache manager used to store and recover data.
    public init(
        apiClient: ArticClientProtocol,
        cacheManager: CacheManagerProtocol?
    ) {
        self.apiClient = apiClient
        self.cacheManager = cacheManager
    }
    
    public func loadArtist(id: Int) async throws -> Artist {
        log("id: \(id)")
        print(String(repeating: "-", count: 80))
        
        // Load from cache
        if let cached = try loadFromCache(id) {
            return cached
        }
        
        // Load from network
        let dto = try await loadFromNetwork(id)
        
        // Store in cache
        await storeInCache(dto)
        
        // Map to return
        return map(dto)
    }
}

// MARK: - Private Cache Handling
private extension ArtistRepository {
    func cacheKeyFor(_ id: Int) -> String {
        "\(String(describing: ArtistDTO.self)).\(id)"
    }
    
    func loadFromCache(_ id: Int) throws -> Artist? {
        guard let cacheManager else {
            log("cacheManager not set")
            return nil
        }
        
        let cacheKey = cacheKeyFor(id)
        log("cacheKey: \(cacheKey)")
        if let dto: ArtistDTO = try cacheManager.loadObject(cacheKey) {
            return map(dto)
        }
        return nil
    }
    
    func storeInCache(_ dto: ArtistDTO) async {
        let cacheKey = cacheKeyFor(dto.id)
        log("cacheKey: \(cacheKey)")
        _ = await cacheManager?.storeObject(dto, key: cacheKey)
    }
}

// MARK: - Private Response Mapper
private extension ArtistRepository {
    func map(_ dto: ArtistDTO) -> Artist {
        ArtistMapper.map(dto: dto)
    }
}


// MARK: - Private
private extension ArtistRepository {
    func loadFromNetwork(_ id: Int) async throws -> ArtistDTO  {
        return try await apiClient.fetchArtist(id: id)
    }
}
