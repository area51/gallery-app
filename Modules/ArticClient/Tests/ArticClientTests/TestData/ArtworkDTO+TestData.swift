import Foundation
import ArticClient

extension ArtworkDTO {
    static func StarryNight(id: Int = 123) -> ArtworkDTO {
        ArtworkDTO(id: id, title: "Starry Night Over the Rhône")
    }
}

extension ArtworkDTO {
    func endpointURL() -> URL {
        URL(string: "https://api.artic.edu/api/v1/artworks?fields=id,title,artist_id,artist_title,image_id")!
    }
}
