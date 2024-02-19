import Foundation
import ArticClient

struct ArtworkResponse: Codable {
    let artworks: [ArtworkDTO]
    let pagination: PaginationDTO
}
