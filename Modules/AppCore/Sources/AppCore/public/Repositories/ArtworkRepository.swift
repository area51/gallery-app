import Foundation
import Commons
import ArticClient

final public class ArtworkRepository: ArtworkRepositoryProtocol, Loggable {
    private let apiClient: ArticClientProtocol
    private let cacheManager: CacheManagerProtocol?
    
    /// Initializes the repository for artworks.
    /// - parameter apiClient: The client used to fetch the data.
    /// - parameter cacheManager: The cache manager used to store and recover data.
    public init(
        apiClient: ArticClientProtocol,
        cacheManager: CacheManagerProtocol?
    ) {
        self.apiClient = apiClient
        self.cacheManager = cacheManager
    }
    
    public func loadArtworks(page: Pagination?) async throws -> ([Artwork], Pagination) {
        log("page: \(page?.currentPage ?? 1))")
        print(String(repeating: "-", count: 80))
        
        // Load from cache
        if let cached = try loadFromCache(page) {
            return cached
        }
        
        // Load from network
        let (artworksDTO, paginationDTO) = try await loadFromNetwork(page: page)
        
        // Store in cache
        await storeInCache(artworksDTO, paginationDTO: paginationDTO)
        
        // Map to return
        return map(artworkDTOs: artworksDTO, paginationDTO: paginationDTO)
    }
}

// MARK: - Private Cache Handling
private extension ArtworkRepository {
    func cacheKeyFor(_ page: Int) -> String {
        "\(String(describing: ArtworkDTO.self)).\(page)"
    }
    
    func loadFromCache(_ page: Pagination?) throws -> ([Artwork], Pagination)? {
        guard let cacheManager else {
            log("cacheManager not set")
            return nil
        }
        let currentPage = (page?.currentPage ?? 0) + 1
        let cacheKey = cacheKeyFor(currentPage)
        let response: ArtworkResponse? = try cacheManager.loadObject(cacheKey)
        return map(response)
    }
    
    func storeInCache(
        _ artworksDTO: [ArtworkDTO],
        paginationDTO: PaginationDTO
    ) async {
        let response = ArtworkResponse(
            artworks: artworksDTO,
            pagination: paginationDTO
        )
        let cacheKey = cacheKeyFor(response.pagination.currentPage)
        _ = await cacheManager?.storeObject(
            response,
            key: cacheKey
        )
    }
}

// MARK: - Private Network Handling
private extension ArtworkRepository {
    func loadFromNetwork(
        page: Pagination?
    ) async throws -> ([ArtworkDTO], PaginationDTO) {
        
        let url = page?.nextUrl
        return try await apiClient.fetchArtworks(url: url)
    }
}

// MARK: - Private Response Mapper
private extension ArtworkRepository {
    func map(_ response: ArtworkResponse?) -> ([Artwork], Pagination)? {
        guard let response else {
            return nil
        }
        
        return map(
            artworkDTOs: response.artworks,
            paginationDTO: response.pagination
        )
    }
    
    func map(
        artworkDTOs: [ArtworkDTO],
        paginationDTO: PaginationDTO
    ) -> ([Artwork], Pagination) {
        
        let artworks = artworkDTOs.map(ArtworkMapper.map(dto:))
        let pagination = PaginationMapper.map(dto: paginationDTO)
        return (artworks, pagination)
    }
}

