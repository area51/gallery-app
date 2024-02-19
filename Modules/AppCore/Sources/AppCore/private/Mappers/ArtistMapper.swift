import Foundation
import ArticClient

struct ArtistMapper {
    
    /// Maps `ArtistDTO` to `Artist`.
    /// - parameter dto: The data transfer object to be mapped.
    /// - returns: The mapped `Artist`.
    static func map(dto: ArtistDTO) -> Artist {
        Artist(
            id: dto.id,
            title: dto.title,
            birthDate: dto.birthDate,
            deathDate: dto.deathDate,
            description: dto.description
        )
    }
}

