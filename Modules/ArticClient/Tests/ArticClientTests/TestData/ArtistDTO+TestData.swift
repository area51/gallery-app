import Foundation
import ArticClient

extension ArtistDTO {
    static func vanGogh(id: Int = 123) -> ArtistDTO {
        ArtistDTO(id: id, title: "Vincent van Gogh")
    }
}

extension ArtistDTO {
    func endpointURL() -> URL {
        URL(string: "https://api.artic.edu/api/v1/artists/\(id)?fields=id,title,birth_date,death_date,description")!
    }
}
