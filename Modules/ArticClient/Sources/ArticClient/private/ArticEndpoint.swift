import Foundation

/// Endpoints for the Artic API
enum ArticEndpoint {
    case artist(Int)
    case artwork
    
    /// The path for the endpoint
    var path: String {
        switch self {
        case .artist(let id): return "/v1/artists/\(id)"
        case .artwork: return "/v1/artworks"
        }
    }
    
    /// The query items for the endpoint
    var queryItems: [URLQueryItem] {
        switch self {
        case .artist:
            return [
                URLQueryItem(
                    name: "fields",
                    value: "id,title,birth_date,death_date,description"
                )
            ]
        case .artwork:
            return [
                URLQueryItem(
                    name: "fields",
                    value: "id,title,artist_id,artist_title,image_id"
                )
            ]
        }
    }
}
