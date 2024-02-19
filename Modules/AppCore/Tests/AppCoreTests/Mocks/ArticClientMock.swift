import Foundation
import ArticClient

class ArticClientMock: ArticClientProtocol {
    var expectedArtistDTO: ArtistDTO?
    var expectedArtworksDTO: [ArtworkDTO]?
    var expectedArtistError: Error?
    var expectedArtworkError: Error?
    
    var fetchArtistCallCount = 0
    var fetchArtistId: Int?
    func fetchArtist(id: Int) async throws -> ArtistDTO {
        fetchArtistCallCount += 1
        fetchArtistId = id
        if let expectedArtistError {
            throw expectedArtistError
        }
        return expectedArtistDTO!
    }
    
    var fetchArtworksCallCount = 0
    func fetchArtworks(url: URL?) async throws -> ([ArtworkDTO], PaginationDTO) {
        fetchArtworksCallCount += 1
        if let expectedArtworkError {
            throw expectedArtworkError
        }
        return (expectedArtworksDTO!, testPaginationDTO)
    }
    
    private var testPaginationDTO: PaginationDTO {
        PaginationDTO(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 1,
            nextUrl: URL(string: "https://api.area51.com/artworks?page=2")!
        )
    }
}
