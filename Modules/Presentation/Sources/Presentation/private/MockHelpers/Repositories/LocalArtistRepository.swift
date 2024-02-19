#if DEBUG
import Foundation
import AppCore

class LocalArtistRepository: ArtistRepositoryProtocol {
    var result: Result<Artist, Error>
    var loadingTime: UInt64
    
    private let oneSecond: UInt64 = 1_000_000_000
    
    init(
        loadingTime: UInt64 = 1,
        result: Result<Artist, Error> = .success(.vanGogh)
    ) {
        self.result = result
        self.loadingTime = loadingTime
    }
    
    func loadArtist(id: Int) async throws -> Artist {
        // Simulate Loading State
        if loadingTime > 0 {
            try await Task.sleep(nanoseconds: loadingTime * oneSecond)
        }
        
        // Return results
        switch result {
        case .success(let artist):
            return artist
        case .failure(let error):
            throw error
        }
    }
}

#endif
