import Foundation

public protocol URLSessionProtocol {
    /// Asynchronously fetches the contents of the specified URL request.
    /// - parameter url: The URL to fetch the contents from.
    /// - returns: The data and response returned by the server.
    /// - throws: An error if the request cannot be made or the response cannot be processed.
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
