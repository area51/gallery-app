import Foundation

/// DTO for the Artwork
public struct ArtworkDTO: Codable, Equatable {
    public let id: Int
    public let title: String
    public let artistId: Int?
    public let artistTitle: String?
    public let imageId: String?
    
    /// Initializes the ArtworkDTO.
    /// Mostly a convinience initializer for testing.
    /// - parameter id: The artwork id
    /// - parameter title: The artwork name
    /// - parameter artistId: The artist id
    /// - parameter artistTitle: The artist name
    /// - parameter imageId: The image id
    public init(
        id: Int,
        title: String,
        artistId: Int? = nil,
        artistTitle: String? = nil,
        imageId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.artistId = artistId
        self.artistTitle = artistTitle
        self.imageId = imageId
    }
}
