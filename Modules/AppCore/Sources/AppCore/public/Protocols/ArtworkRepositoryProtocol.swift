import Foundation
import ArticClient

public protocol ArtworkRepositoryProtocol: AnyObject {
    /// Loads the first page of artworks.
    /// - returns: A tuple containing the list of artworks and the pagination information.
    func loadArtworks() async throws -> ([Artwork], Pagination)
    
    /// Loads a list of artworks.
    /// - parameter page: The page to load, or `nil` to load the first page.
    /// - returns: A tuple containing the list of artworks and the pagination information.
    func loadArtworks(page: Pagination?) async throws -> ([Artwork], Pagination)
}

// MARK: - Default implementations
public extension ArtworkRepositoryProtocol {
    func loadArtworks() async throws -> ([Artwork], Pagination) {
        try await loadArtworks(page: nil)
    }
}
