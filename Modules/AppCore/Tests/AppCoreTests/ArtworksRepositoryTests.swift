import XCTest
@testable import AppCore
import ArticClient

final class ArtworkRepositoryTests: XCTestCase {
    var repository: ArtworkRepository!
    var apiClientMock: ArticClientMock!
    var cacheMock: CacheMock!
    var cacheManagerMock: CacheManagerMock!
    
    override func setUp() {
        super.setUp()
        apiClientMock = ArticClientMock()
        cacheMock = CacheMock()
        cacheManagerMock = CacheManagerMock(cache: cacheMock)
        repository = ArtworkRepository(
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
    
    func testLoadArtworksFromCache() async throws {
        //Given
        let page = Pagination.firstPage
        let cacheKey = "ArtworkDTO.2"
        let artwork = Artwork(id: 1, title: "Test Artwork")
        let artworkDTO = ArtworkDTO(id: 1, title: artwork.title)
        let toCache = ArtworkResponse(
            artworks: [artworkDTO],
            pagination: .firstPage
        )
        let encoder = cacheManagerMock.encoder
        let cacheData = try encoder.encode(toCache)
        cacheMock.set(cacheKey, cacheData)
        
        // When
        let (respArtworks, respPage) = try await repository.loadArtworks(page: page)
        
        // Then
        XCTAssertEqual([artwork], respArtworks)
        XCTAssertEqual(page, respPage)
        XCTAssertTrue(cacheManagerMock.loadCalled)
        XCTAssertEqual(cacheManagerMock.loadCalledWithKey, cacheKey)
        XCTAssertEqual(apiClientMock.fetchArtworksCallCount, 0)
    }
    
    func testLoadArtworkFromNetwork() async throws {
        // Given
        let artwork = Artwork(id: 1, title: "Test Artwork")
        let artworkDTO = ArtworkDTO(id: 1, title: artwork.title)
        let page = Pagination.firstPage
        let toCache = ArtworkResponse(
            artworks: [artworkDTO],
            pagination: .firstPage
        )
        apiClientMock.expectedArtworksDTO = toCache.artworks
        
        // When
        _ = try await repository.loadArtworks(page: page)
        
        // Then
        XCTAssertEqual(apiClientMock.fetchArtworksCallCount, 1)
    }
    
    // MARK: - Test Storing
    
    func testStoreArtworkInCache() async throws {
        // Given
        let artwork = Artwork(id: 1, title: "Test Artwork")
        let artworkDTO = ArtworkDTO(id: 1, title: artwork.title)
        let page = Pagination.firstPage
        let toCache = ArtworkResponse(
            artworks: [artworkDTO],
            pagination: .firstPage
        )
        apiClientMock.expectedArtworksDTO = toCache.artworks
        
        // When
        _ = try await repository.loadArtworks(page: page)
        
        // Then
        XCTAssertTrue(cacheManagerMock.storeCalled)
        XCTAssertEqual(cacheManagerMock.storeCalledWithKey, "ArtworkDTO.1")
    }
    
    // MARK: - Test Error Throws
    func testFailedNetworkRequestThrows() async throws {
        // Given
        let expectedError = NSError(
            domain: "com.area51.bitso.tests",
            code: 404
        )
        
        apiClientMock.expectedArtworkError = expectedError
        
        do {
            // When
            _ = try await repository.loadArtworks(page: .firstPage)
            
            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
            XCTAssertEqual(apiClientMock.fetchArtworksCallCount, 1)
        }
    }
}

