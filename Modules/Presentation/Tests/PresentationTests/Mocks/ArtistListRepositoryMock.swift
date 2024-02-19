import Foundation
import AppCore

class ArtistListRepositoryMock: ArtistRepositoryProtocol {
    var result: Artist?
    
    func loadArtist(id: Int) async throws -> Artist {
        if let result = result {
            return result
        }
        throw NSError(domain: "com.ArtistListRepositoryMock.result.missing", code: 404)
    }
}
