import Foundation
import Network

/// /// A mock implementation of `NetworkClientProtocol` for testing.
final class NetworkClientMock: NetworkClientProtocol {
    var fetchCallCount = 0
    var fetchURLs: [URL] = []
    var expectedResponse: Data!
    
    func fetch(url: URL) async throws -> Data {
        fetchCallCount += 1
        fetchURLs.append(url)
        return expectedResponse
    }
}
