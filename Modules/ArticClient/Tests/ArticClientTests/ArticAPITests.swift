import XCTest
@testable import ArticClient
import Network

final class ArticClientTests: XCTestCase {

    // MARK: - Properties
    
    var client: ArticClient!
    var encoder: JSONEncoder!
    var networkClientMock: NetworkClientMock!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        encoder = JSONEncoder()
        networkClientMock = NetworkClientMock()
        client = ArticClient(
            decoder: JSONDecoderFactory.makeDefault(),
            networkClient: networkClientMock
        )
    }
    
    override func tearDown() {
        client = nil
        encoder = nil
        networkClientMock = nil
        super.tearDown()
    }
    
    // MARK: - Artist Test Cases
    
    /// Test the fetchArtist method when no cached data exists
    func testFetchArtist_returnsNetworkData() async throws {
        // Given
        let artistDTO = ArtistDTO.vanGogh()
        let artistId = artistDTO.id
        let expectedURL = artistDTO.endpointURL()
        let expectedResponse = ArtistResponse.Get(data: artistDTO)
        let expectedResponseData: Data = try encoder.encode(expectedResponse)
        networkClientMock.expectedResponse = expectedResponseData
        
        // When
        let result = try await client.fetchArtist(id: artistId)
        
        // Then
        XCTAssertEqual(result, artistDTO)
        XCTAssertEqual(networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(networkClientMock.fetchURLs.first, expectedURL)
    }

    // MARK: - Artwork Test Cases
    
    /// Test the fetchArtworks method when an optional URL is nil
    func testFetchArtworks_whenOptionalURLIsNil_loadsFromDefaultURL() async throws {
        // Given
        let artworkDTO = ArtworkDTO.StarryNight()
        let paginationDTO = PaginationDTO.firstPage
        let expectedURL = artworkDTO.endpointURL()
        let expectedResponse = ArtworkResponse.Get(data: [artworkDTO], pagination: paginationDTO)
        let expectedResponseData: Data = try encoder.encode(expectedResponse)
        networkClientMock.expectedResponse = expectedResponseData

        // When
        let (artworks, pagination) = try await client.fetchArtworks(url: nil)

        // Then
        XCTAssertEqual(artworks, [artworkDTO])
        XCTAssertEqual(pagination, paginationDTO)
        XCTAssertEqual(networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(networkClientMock.fetchURLs.first, expectedURL)
    }
    
    /// Test the fetchArtworks method when an optional URL is not nil
    func testFetchArtworks_whenOptionalURLIsNotNil_loadsFromProvidedURL() async throws {
        // Given
        let artworkDTO = ArtworkDTO.StarryNight()
        let paginationDTO = PaginationDTO.firstPage
        let expectedURL = URL(string: "https://api.area51.com/artworks")!
        let expectedResponse = ArtworkResponse.Get(data: [artworkDTO], pagination: paginationDTO)
        let expectedResponseData: Data = try encoder.encode(expectedResponse)
        networkClientMock.expectedResponse = expectedResponseData

        // When
        let (artworks, pagination) = try await client.fetchArtworks(url: expectedURL)

        // Then
        XCTAssertEqual(artworks, [artworkDTO])
        XCTAssertEqual(pagination, paginationDTO)
        XCTAssertEqual(networkClientMock.fetchCallCount, 1)
        XCTAssertEqual(networkClientMock.fetchURLs.first, expectedURL)
    }
}
