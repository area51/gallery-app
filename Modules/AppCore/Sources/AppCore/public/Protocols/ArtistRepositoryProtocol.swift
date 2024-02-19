import Foundation
import ArticClient

public protocol ArtistRepositoryProtocol: AnyObject {
    /// Loads an artist by its identifier.
    /// - parameter id: The unique identifier of the artist.
    /// - returns: The artist object.
    func loadArtist(id: Int) async throws -> Artist
}
