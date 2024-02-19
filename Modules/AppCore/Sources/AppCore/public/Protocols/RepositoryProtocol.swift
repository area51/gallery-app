import Foundation

public protocol RepositoryProtocol: AnyObject {
    var artwork: ArtworkRepositoryProtocol { get }
    var artist: ArtistRepositoryProtocol { get }
}
