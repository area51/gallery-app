import Foundation
import Commons
import Network

public struct ArticClientFactory {
    /// Creates a production instance of ArticClient
    static public func make(
        decoder: JSONDecoderProtocol = JSONDecoderFactory.makeDefault(),
        networkClient: NetworkClientProtocol = NetworkClient()
    ) -> ArticClient {
        ArticClient(
            decoder: JSONDecoderFactory.makeDefault(),
            networkClient: NetworkClient()
        )
    }
}
