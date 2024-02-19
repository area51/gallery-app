import Foundation
import AppCore

class ArtworkListRepositoryMock: ArtworkRepositoryProtocol {
    var result: ([Artwork], Pagination)?
    
    func loadArtworks(page: Pagination?) async throws -> ([Artwork], Pagination) {
        if let result = result {
            return result
        }
        throw NSError(domain: "com.ArtworkListRepositoryMock.result.missing", code: 404)
    }
}
