import Foundation
import Commons

/// A very simple network layer, just with what we need for this project.
/// Just fetches the data and sends it back without any transformation.
/// Only handle GET requests.
public protocol NetworkClientProtocol {
    /// Fetches a `Decodable` object from the given URL.
    /// - parameter url: The URL to fetch the object from.
    /// - returns: The `Data` object fetched from the given URL.
    /// - throws: An error if the object cannot be fetched or decoded.
    func fetch(url: URL) async throws -> Data
}

public struct NetworkClient: NetworkClientProtocol, Loggable {
    private let session: URLSessionProtocol
    
    /// Creates a new instance of `NetworkClient`.
    ///  - parameter session: The session to use for network requests. Default is `URLSession.shared`.
    ///  - returns: A new instance of `NetworkClient`.
    public init(
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.session = session
    }
    
    public func fetch(url: URL) async throws -> Data {
        log("Fetching data from: \(url)")
        let (data, _) = try await session.data(from: url)
        return data
    }
}
