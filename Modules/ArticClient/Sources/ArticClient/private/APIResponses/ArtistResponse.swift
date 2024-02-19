import Foundation

/// Response from the Artist API
struct ArtistResponse {
    
    /// Response from the Artist GET API
    struct Get: Decodable {
        let data: ArtistDTO
    }
}
