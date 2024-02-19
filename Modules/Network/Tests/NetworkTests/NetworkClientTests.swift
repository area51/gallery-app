import XCTest
@testable import Network

final class NetworkClientTests: XCTestCase {

    // MARK: - Properties
    
    var networkClient: NetworkClient!
    var sessionMock: URLSessionMock!
    
    // MARK: - Setup
    
    override func tearDown() {
        networkClient = nil
        sessionMock = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    /// Test that the `fetch` method returns a the Data  object when the response is successful.
    func testFetch_whenRequestSucceeds() async throws {
        // Given
        let url = URL(string: "https://area51.com")!
        let expectedData = Data()
        sessionMock = URLSessionMock(data: Data(), response: URLResponse(), error: nil)
        networkClient = NetworkClient(session: sessionMock)
        
        // When
        do {
            let fetchedData = try await networkClient.fetch(url: url)
            // Then
            XCTAssertEqual(fetchedData, expectedData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Test that the `fetch` method throws the correct error when the response is not successful.
    func testFetch_whenRequestFails() async throws {
        // Given
        let url = URL(string: "https://area51.com")!
        let expectedError = NSError(domain: "com.area51.bitso.tests", code: 404)
        sessionMock = URLSessionMock(data: nil, response: nil, error: expectedError)
        networkClient = NetworkClient(session: sessionMock)
        
        // When
        do {
            _ = try await networkClient.fetch(url: url)
            
            // Then
            XCTFail("Expected error to be thrown")
        } catch {
            // Then
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
}
