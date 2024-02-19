import XCTest
@testable import AppCore
import ArticClient

class ArtistRepositoryTests: XCTestCase {
    var repository: ArtistRepository!
    var apiClientMock: ArticClientMock!
    var cacheMock: CacheMock!
    var cacheManagerMock: CacheManagerMock!
    
    override func setUp() {
        super.setUp()
        apiClientMock = ArticClientMock()
        cacheMock = CacheMock()
        cacheManagerMock = CacheManagerMock(cache: cacheMock)
        repository = ArtistRepository(
            apiClient: apiClientMock,
            cacheManager: cacheManagerMock
        )
    }
    
    override func tearDown() {
        repository = nil
        apiClientMock = nil
        cacheManagerMock = nil
        cacheMock = nil
        super.tearDown()
    }
    
    // MARK: - Test Loading
    
    func testLoadArtistFromCache() async throws {
        // Given
        let artistID = 1
        let cacheKey = "ArtistDTO.1"
        let artist = Artist(id: artistID, title: "Test Artist")
        let artistDTO = ArtistDTO(id: artistID, title: artist.title)
        let encoder = cacheManagerMock.encoder
        let artistData = try encoder.encode(artistDTO)
        cacheMock.set(cacheKey, artistData)
        
        // When
        let loadedArtist = try await repository.loadArtist(id: artistID)
        
        // Then
        XCTAssertEqual(loadedArtist, artist)
        XCTAssertTrue(cacheManagerMock.loadCalled)
        XCTAssertEqual(cacheManagerMock.loadCalledWithKey, cacheKey)
        XCTAssertEqual(apiClientMock.fetchArtistCallCount, 0)
    }
    
    func testLoadArtistFromNetwork() async throws {
        // Given
        let artistID = 1
        let artist = Artist(id: artistID, title: "Test Artist")
        let artistDTO = ArtistDTO(id: artistID, title: "Test Artist")
        apiClientMock.expectedArtistDTO = artistDTO
        
        // When
        let loadedArtist = try await repository.loadArtist(id: artistID)
        
        // Then
        XCTAssertEqual(loadedArtist, artist)
        XCTAssertTrue(cacheManagerMock.loadCalled)
        XCTAssertEqual(cacheManagerMock.loadCalledWithKey, "ArtistDTO.1")
        XCTAssertTrue(cacheManagerMock.storeCalled)
        XCTAssertEqual(cacheManagerMock.storeCalledWithKey, "ArtistDTO.1")
        XCTAssertEqual(apiClientMock.fetchArtistCallCount, 1)
        XCTAssertEqual(apiClientMock.fetchArtistId, artistID)
    }
    
    // MARK: - Test Storing
    
    func testStoreArtistInCache() async throws {
        // Given
        let artistID = 1
        let cacheKey = "ArtistDTO.1"
        let artist = Artist(id: artistID, title: "Test Artist")
        let artistDTO = ArtistDTO(id: artistID, title: artist.title)
        apiClientMock.expectedArtistDTO = artistDTO
        
        // When
        let loadedArtist = try await repository.loadArtist(id: artistID)
        
        // Then
        XCTAssertEqual(loadedArtist, artist)
        XCTAssertTrue(cacheManagerMock.loadCalled)
        XCTAssertEqual(cacheManagerMock.loadCalledWithKey, cacheKey)
        XCTAssertTrue(cacheManagerMock.storeCalled)
        XCTAssertEqual(cacheManagerMock.storeCalledWithKey, cacheKey)
        XCTAssertEqual(apiClientMock.fetchArtistCallCount, 1)
        XCTAssertEqual(apiClientMock.fetchArtistId, artistID)
    }
    
    // MARK: - Test Error Throws
    func testFailedNetworkRequestThrows() async throws {
        // Given
        let expArtistId = 1
        let expectedError = NSError(
            domain: "com.area51.bitso.tests",
            code: 404
        )
        
        apiClientMock.expectedArtistError = expectedError
        
        do {
            // When
            _ = try await repository.loadArtist(id: expArtistId)
            
            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
            XCTAssertEqual(apiClientMock.fetchArtistId, expArtistId)
            XCTAssertEqual(apiClientMock.fetchArtistCallCount, 1)
        }
    }
}
