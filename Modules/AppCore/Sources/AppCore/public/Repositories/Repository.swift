import Foundation

public class Repository: RepositoryProtocol {
    public let artwork: ArtworkRepositoryProtocol
    public let artist: ArtistRepositoryProtocol
    
    public init(
        artwork: ArtworkRepositoryProtocol,
        artist: ArtistRepositoryProtocol
    ) {
        self.artwork = artwork
        self.artist = artist
    }
}
