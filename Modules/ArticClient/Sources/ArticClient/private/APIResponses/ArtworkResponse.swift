import Foundation

/// Response from the Artwork API
struct ArtworkResponse {
    
    /// Response from the Artwork GET API
    struct Get: Decodable {
        let data: [ArtworkDTO]
        let pagination: PaginationDTO
    }
}
