import XCTest
import AppCore
@testable import Presentation

class ArtworkListTests: XCTestCase {
    
    var dataModel: ArtworkList.DataModel!
    var coordinator: ArtworkList.Coordinator!
    var repositoryMock: ArtworkListRepositoryMock!
    
    override func setUp() {
        super.setUp()
        dataModel = ArtworkList.DataModel(viewState: .empty)
        repositoryMock = ArtworkListRepositoryMock()
        coordinator = ArtworkList.Coordinator(
            dataModel: dataModel,
            repository: repositoryMock
        )
    }
    
    override func tearDown() {
        dataModel = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(dataModel.viewState, .empty)
        XCTAssertEqual(dataModel.artworks.count, 0)
        XCTAssertNil(dataModel.lastPage)
        XCTAssertFalse(dataModel.shouldLoadMore)
        XCTAssertNil(dataModel.error)
        XCTAssertFalse(dataModel.showError)
        XCTAssertFalse(dataModel.errorAllowsRetry)
    }
    
    func testPerformLoadArtworks() async throws {
        // Given
        let artworks = [Artwork(id: 1, title: "Artwork 1")]
        let pagination = Pagination.firstPage
        repositoryMock.result = (artworks, pagination)
        
        do {
            // When
            try await coordinator.perform(action: .loadArtworks(page: nil))
            
            // Then
            XCTAssertEqual(dataModel.lastPage, pagination)
            XCTAssertFalse(dataModel.shouldDiscardOldData)
            XCTAssertEqual(
                self.dataModel.viewState,
                .loaded(artworks: artworks, lastPage: pagination)
            )
        } catch {
            // Then
            XCTFail("Error loading artworks: \(error)")
        }
        
    }
    
    func testPerformRefreshArtworks() async throws {
        //Given
        self.dataModel.artworks = [Artwork(id: 100, title: "Artwork 100")]
        let artworks = [Artwork(id: 1, title: "Artwork 1")]
        let pagination = Pagination.firstPage
        repositoryMock.result = (artworks, pagination)
        
        do {
            // When
            try await coordinator.perform(action: .refreshArtworks)
            
            // Then
            XCTAssertEqual(dataModel.lastPage, pagination)
            XCTAssertTrue(dataModel.shouldLoadMore)
            XCTAssertFalse(dataModel.shouldDiscardOldData)
            XCTAssertEqual(
                self.dataModel.viewState,
                .loaded(artworks: artworks, lastPage: pagination)
            )
        } catch {
            // Then
            XCTFail("Error loading artworks: \(error)")
        }
    }
}
