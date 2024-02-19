import Foundation
import Network

/// A mock implementation of `URLSessionProtocol` for testing.
final class URLSessionMock: URLSessionProtocol {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        // 1: If error, throw it immediately
        if let error {
            throw error
        }
        // 2: If data and response are not nil, return them
        if let data = data, let response = response {
            return (data, response)
        }
        // 3: If only response exists
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
                case 200..<300:
                    // Response is successful but without data
                    return (Data(), response)
            default:
                // It's an error, return error with the response status code
                throw NSError(domain: "MockError", code: response.statusCode)
            }
        }
        // 4: If none of the above, return unknown error
        throw NSError(domain: "MockError", code: NSURLErrorUnknown)
    }
}
