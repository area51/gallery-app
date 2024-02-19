import XCTest
import AppCore
@testable import Presentation

class ArtistDetailTests: XCTestCase {
    var artistId: Int!
    var imageConfig: ArtworkPresentationConfig!
    var dataModel: ArtistDetail.DataModel!
    var coordinator: ArtistDetail.Coordinator!
    var repositoryMock: ArtistListRepositoryMock!
    
    override func setUp() {
        super.setUp()
        artistId = 1
        imageConfig = ArtworkPresentationConfig(
            imageURL: nil,
            originalWidth: nil
        )
        dataModel = ArtistDetail.DataModel(
            artistId: artistId,
            imageConfig: imageConfig,
            viewState: .initial
        )
        repositoryMock = ArtistListRepositoryMock()
        coordinator = ArtistDetail.Coordinator(
            dataModel: dataModel,
            repository: repositoryMock
        )
    }
    
    override func tearDown() {
        dataModel = nil
        coordinator = nil
        artistId = nil
        imageConfig = nil
        repositoryMock = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(dataModel.viewState, .initial)
        XCTAssertEqual(dataModel.imageConfig, imageConfig)
        XCTAssertEqual(dataModel.artistId, artistId)
        XCTAssertNil(dataModel.artist)
        XCTAssertNil(dataModel.error)
        XCTAssertFalse(dataModel.showError)
        XCTAssertFalse(dataModel.errorAllowsRetry)
    }
    
    func testPerformLoadArtist() async throws {
        // Given
        let artist = Artist.vanGogh
        repositoryMock.result = artist
        
        do {
            // When
            try await coordinator.perform(action: .loadArtist(id: artistId))
            
            // Then
            XCTAssertEqual(self.dataModel.viewState, .loaded(artist))
            XCTAssertEqual(dataModel.imageConfig, imageConfig)
            XCTAssertEqual(dataModel.artistId, artistId)
            XCTAssertEqual(dataModel.artist, artist)
            XCTAssertNil(dataModel.error)
            XCTAssertFalse(dataModel.showError)
            XCTAssertFalse(dataModel.errorAllowsRetry)
        } catch {
            // Then
            XCTFail("Error loading artworks: \(error)")
        }
        
    }
}

extension ArtworkPresentationConfig: Equatable {
    public static func == (lhs: ArtworkPresentationConfig, rhs: ArtworkPresentationConfig) -> Bool {
        return lhs.imageURL == rhs.imageURL && 
            lhs.originalWidth == rhs.originalWidth &&
            lhs.minWidth == rhs.minWidth &&
            lhs.maxWidth == rhs.maxWidth &&
            lhs.minHeight == rhs.minHeight &&
            lhs.maxHeight == rhs.maxHeight &&
            lhs.backgroundColor == rhs.backgroundColor
    }
}
