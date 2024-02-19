import Foundation

/// Artwork business object
public struct Artwork: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let artistId: Int?
    public let artistTitle: String?
    public let imageId: String?
    
    /// Initializes a new instance of the `Artwork` struct.
    ///   - parameter id: The unique identifier of the artwork.
    ///   - parameter title: The title of the artwork.
    ///   - parameter artistId: The unique identifier of the artist. Default value is `nil`.
    ///   - parameter artistTitle: The title of the artist. Default value is `nil`.
    ///   - parameter imageId: The unique identifier of the image. Default value is `nil`.
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
    
    /// Hashes the essential components of the object.
    /// Just for convinience to already have it in all objects and also gain `Equatable` conformance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
