import SwiftUI
import Combine
import Commons
import AppCore

enum ArtistDetail {}

extension ArtistDetail {
    final class DataModel: ObservableObject {
        let artistId: Int?
        let imageConfig: ArtworkPresentationConfig
        @Published var artist: Artist?
        @Published var viewState: ViewState
        
        // Error related properties
        @Published var error: Error? = nil
        @Published var showError: Bool = false
        @Published var errorAllowsRetry: Bool = false
        
        private var cancellables = Set<AnyCancellable>()
        
        init(
            artistId: Int?,
            imageConfig: ArtworkPresentationConfig,
            viewState: ViewState = .initial
        ) {
            self.artistId = artistId
            self.imageConfig = imageConfig
            self.viewState = viewState
            
            self.$viewState
                .sink(receiveValue: { [weak self] viewState in
                    log("viewState changed: \(viewState.description)")
                    guard let self else { return }
                    // Prevent inconsistent view states
                    switch viewState {
                    case .initial:
                        self.resetState()
                    case .loaded(let artist):
                        self.artist = artist
                    case .inError(let error, let retry):
                        self.error = error
                        self.showError = true
                        self.errorAllowsRetry = retry
                    }
                })
                .store(in: &cancellables)
        }
        
        private func resetState() {
            self.artist = nil
            self.error = nil
            self.showError = false
            self.errorAllowsRetry = false
        }
    }
    
    enum Actions {
        case loadArtist(id: Int)
    }
    
    enum ViewState: Equatable, CustomStringConvertible {
        case initial
        case loaded(Artist)
        case inError(Error, retry: Bool)
        
        var description: String {
            switch self {
            case .initial:
                return "initial"
            case .loaded(let artist):
                return "loaded(artist: \(artist.id))"
            case .inError(let error, let retry):
                return "inError(\(error.localizedDescription), retry: \(retry))"
            }
        }
        
        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial):
                return true
            case (.loaded(let lhsArtist), .loaded(let rhsArtist)):
                return lhsArtist == rhsArtist
            case (.inError(let lhsError, let lhsRetry), .inError(let rhsError, let rhsRetry)):
                let equalErrors = lhsError.localizedDescription == rhsError.localizedDescription
                let equalRetry = lhsRetry == rhsRetry
                return equalErrors && equalRetry
            default:
                return false
            }
        }
    }
    
    final class Coordinator: ObservableObject, ViewCoordinator, Loggable {
        private var dataModel: DataModel
        private weak var repository: (any ArtistRepositoryProtocol)?
        
        init(
            dataModel: DataModel,
            repository: (any ArtistRepositoryProtocol)? = nil
        ) {
            self.dataModel = dataModel
            self.repository = repository
            
            if let artistId = self.dataModel.artistId {
                Task { @MainActor in
                    do {
                        try await self.perform(action: .loadArtist(id: artistId))
                    } catch {
                        self.dataModel.viewState = .inError(error, retry: true)
                    }
                }
            }
        }
        
        @ViewBuilder
        public var contentView: some View {
            ContentView(
                dataModel: self.dataModel,
                actionHandler: self.perform(action:)
            )
        }
        
        @MainActor
        public func perform(action: Actions) async throws {
            switch action {
            case let .loadArtist(id):
                guard let repository else {
                    log("No repository available")
                    return
                }
                let artist = try await repository.loadArtist(id: id)
                log("retrieved artist: \(id)")
                self.dataModel.artist = artist
                self.dataModel.viewState = .loaded(artist)
            }
        }
    }
}

extension ArtistDetail {
    struct ContentView: View {
        typealias ActionHandler = (Actions) async throws -> Void
        
        @ObservedObject var dataModel: DataModel
        private let actionHandler: ActionHandler
        
        init(
            dataModel: DataModel,
            actionHandler: @escaping ActionHandler
        ) {
            self.dataModel = dataModel
            self.actionHandler = actionHandler
        }
        
        var body: some View {
            self.artistDetails(for: self.dataModel.artist)
                .alert(
                    "Ooops, something went wrong",
                    isPresented: self.$dataModel.showError,
                    presenting: self.dataModel.error,
                    actions: { error in
                        if let id = self.dataModel.artistId,
                           self.dataModel.errorAllowsRetry {
                            Button("Retry") {
                                self.perform(action: .loadArtist(id: id))
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {
                            self.dismissError()
                        }
                })
        }
        
        @ViewBuilder
        func artistDetails(for artist: Artist?) -> some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Spacer()
                        AsyncArtImage(config: self.dataModel.imageConfig)
                        Spacer()
                    }
                    
                    artistInformation(artist)
                    
                    Spacer()
                }
                .padding(.top, 20)
                .padding([.leading, .trailing], 32)
            }
        }
        
        @ViewBuilder
        func artistInformation(_ artist: Artist?) -> some View {
            if let artist {
                infoField(
                    "Title:",
                    value: artist.title
                )
                
                infoField(
                    "Birth year:",
                    value: artist.birthDate,
                    fallbackText: "Unknown"
                )
                
                infoField(
                    "Death year:",
                    value: artist.deathDate,
                    fallbackText: "Unknown or still alive..."
                )
                
                infoTextOrEmptyView(artist.description)
            } else if dataModel.artistId != nil {
                Text("Loading artist information...")
            } else {
                Text("The artist is unknown")
            }
        }
        
        @ViewBuilder
        func infoField(_ label: String, value: String) -> some View {
            HStack {
                Text(label)
                Text(value)
            }
        }
        
        @ViewBuilder
        func infoField(_ label: String, value: Int?, fallbackText: String) -> some View {
            if let value {
                infoField(label, value: "\(value)")
            } else {
                infoField(label, value: fallbackText)
            }
        }
        
        @ViewBuilder
        func infoTextOrEmptyView(_ text: String?) -> some View {
            if let text {
                Text(text)
                    .font(.caption)
            }
        }
        
        private func perform(action: Actions) {
            Task { @MainActor in
                do {
                    log("perform action \(action)")
                    try await self.actionHandler(action)
                } catch {
                    self.handleError(error)
                }
            }
        }
        
        private func dismissError() {
            self.dataModel.error = nil
            self.dataModel.showError = false
            self.dataModel.errorAllowsRetry = false
        }
        
        private func handleError(_ error: Error) {
            log("loadArtworks failed: \(error.localizedDescription)")
            self.dataModel.viewState = .inError(error, retry: true)
        }
    }
}
