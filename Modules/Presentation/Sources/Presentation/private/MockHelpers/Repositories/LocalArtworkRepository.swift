#if DEBUG
import Foundation
import AppCore

class LocalArtworkRepository: ArtworkRepositoryProtocol {
    var result: Result<([Artwork], Pagination), Error>
    var loadingTime: UInt64
    
    private let oneSecond: UInt64 = 1_000_000_000
    
    init(
        loadingTime: UInt64 = 1,
        result: Result<([Artwork], Pagination), Error> = .success(([], .firstPage))
    ) {
        self.result = result
        self.loadingTime = loadingTime
    }
    
    func loadArtworks(page: Pagination?) async throws -> ([Artwork], Pagination) {
        // Simulate Loading State
        if loadingTime > 0 {
            try await Task.sleep(nanoseconds: loadingTime * oneSecond)
        }
        // Return results
        switch result {
        case .success(let artworks):
            return artworks
        case .failure(let error):
            throw error
        }
        
    }
}

#endif
