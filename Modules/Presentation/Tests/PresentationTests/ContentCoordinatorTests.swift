import XCTest
import AppCore
@testable import Presentation

final class ContentCoordinatorTests: XCTestCase {
    
    var contentCoordinator: ContentCoordinator!
    
    override func setUp() {
        super.setUp()
        contentCoordinator = ContentCoordinator(repository: nil)
    }
    
    override func tearDown() {
        contentCoordinator = nil
        super.tearDown()
    }
    
    func testContentViewIsNotNil() {
        XCTAssertNotNil(contentCoordinator.contentView)
    }
    
    func testPerformRefreshAction() async throws {
        do {
            try await contentCoordinator.perform(action: .refresh)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
