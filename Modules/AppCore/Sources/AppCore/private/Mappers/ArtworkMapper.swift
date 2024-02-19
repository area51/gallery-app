import Foundation
import ArticClient

struct ArtworkMapper {
    
    /// Maps `ArtworkDTO` to `Artwork`.
    /// - parameter dto: The data transfer object to be mapped.
    /// - returns: The mapped `Artwork` object.
    static func map(dto: ArtworkDTO) -> Artwork {
        Artwork(
            id: dto.id,
            title: dto.title,
            artistId: dto.artistId,
            artistTitle: dto.artistTitle,
            imageId: dto.imageId
        )
    }
}
