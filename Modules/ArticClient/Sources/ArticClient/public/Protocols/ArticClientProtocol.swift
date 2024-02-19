import Foundation

public protocol ArticClientProtocol {
    /// Fetches the list of artists
    /// - parameter id: The artist id to fetch
    /// - returns: The artist data
    /// - throws: An error of type `NSError` or `DecodingError`
    func fetchArtist(id: Int) async throws -> ArtistDTO
    
    /// Fetches the list of artworks
    /// - parameter optionalURL: The optional URL to fetch. If not present will fetch the first page
    /// - returns: A  list of artworks  and pagination information
    /// - throws: An error of type `NSError` or `DecodingError`
    func fetchArtworks(url optionalURL: URL?) async throws -> ([ArtworkDTO], PaginationDTO)
}
