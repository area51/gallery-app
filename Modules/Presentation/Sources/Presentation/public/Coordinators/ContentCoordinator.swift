import SwiftUI
import AppCore

public final class ContentCoordinator: ObservableObject, ViewCoordinator {
    weak var repository: (any RepositoryProtocol)?
    
    lazy var artworkCoordinator = ArtworkList.Coordinator(
        dataModel: ArtworkList.DataModel(),
        repository: self.repository?.artwork
    )
    
    public init(repository: (any RepositoryProtocol)? = nil) {
        self.repository = repository
    }
    
    @ViewBuilder 
    public var contentView: some View {
        NavigationStack {
            self.artworkCoordinator.contentView
                .navigationDestination(for: Artwork.self) { [weak self] artwork in
                    self?.artistDetailCoordinator(for: artwork)
                    .contentView
                }
        }
    }
    
    public func perform(action: Actions) async throws {
        switch action {
        case .refresh:
            print("REFRESH")
        }
    }
    
    public enum Actions {
        // This is not needed for this app, but is a nice template to leave
        // in case this was going to grow and became a real app some global actions would be
        // handy
        case refresh
    }
}

private extension ContentCoordinator {
    private func artistDetailCoordinator(for artwork: Artwork) -> ArtistDetail.Coordinator {
        let imageConfig = ArtworkPresentationConfig.config(
            for: artwork,
            presentation: .normal
        )
        return ArtistDetail.Coordinator(
            dataModel: ArtistDetail.DataModel(
                artistId: artwork.artistId,
                imageConfig: imageConfig
            ),
            repository: self.repository?.artist
        )
    }
}
