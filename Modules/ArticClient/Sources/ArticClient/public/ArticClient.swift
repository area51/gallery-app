import Foundation
import Commons
import Network

public final class ArticClient: ArticClientProtocol, Loggable {
    private let networkClient: NetworkClientProtocol
    private let decoder: JSONDecoderProtocol
    
    /// Initializes the ArticClient
    /// - parameter decoder: The decoder to use for decoding responses
    /// - parameter networkClient: The network client to use
    public init(
        decoder: JSONDecoderProtocol,
        networkClient: NetworkClientProtocol
    ) {
        self.decoder = decoder
        self.networkClient = networkClient
    }
    
    public func fetchArtist(id: Int) async throws -> ArtistDTO {
        log("id: \(id)")
        let url = buildURL(for: .artist(id))
        let response: ArtistResponse.Get = try await fetch(url: url)
        return response.data
    }
    
    public func fetchArtworks(url optionalURL: URL?) async throws -> ([ArtworkDTO], PaginationDTO) {
        let url = optionalURL ?? buildURL(for: .artwork)
        log("url: \(url)")
        let response: ArtworkResponse.Get = try await fetch(url: url)
        return (response.data, response.pagination)
    }
}

// MARK - Network Fetch Helpers
private extension ArticClient {
    /// Fetches a decodable object from the given URL
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let typeId = String(describing: T.self)
        log("type: \(typeId)")
        let data = try await networkClient.fetch(url: url)
        return try decoder.decode(T.self, from: data)
    }

    /// Builds the URL for a given endpoint
    func buildURL(for endpoint: ArticEndpoint) -> URL {
        URL(string: "https://api.artic.edu/api")!
            .appendingPathComponent(endpoint.path)
            .appending(queryItems: endpoint.queryItems)
    }
}

