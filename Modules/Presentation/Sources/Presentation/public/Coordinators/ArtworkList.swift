import SwiftUI
import Combine
import Commons
import AppCore
import Collections

enum ArtworkList {}

extension ArtworkList {
    public enum Actions: CustomStringConvertible {
        case loadArtworks(page: Pagination?)
        case refreshArtworks
        
        public var description: String {
            switch self {
            case .loadArtworks(let page):
                let nextPageNumber = (page?.currentPage ?? 0) + 1
                return "loadArtworks(page: \(nextPageNumber))"
            case .refreshArtworks:
                return "refreshArtworks"
            }
        }
    }
}

extension ArtworkList {
    final class DataModel: ObservableObject {
        @Published var viewState: ViewState
        
        // The artworks to show
        @Published var artworks: OrderedSet<Artwork> = []
        // Handles pull to refresh
        @Published var shouldDiscardOldData: Bool = false
        
        // Pagination handling
        @Published var lastPage: Pagination?
        @Published var shouldLoadMore: Bool = false
        
        // Error related properties
        @Published var error: Error? = nil
        @Published var showError: Bool = false
        @Published var errorAllowsRetry: Bool = false
        
        private var cancellables = Set<AnyCancellable>()
        
        init(viewState: ViewState = .empty) {
            self.viewState = viewState
            
            self.$viewState
                .sink(receiveValue: { [weak self] viewState in
                    log("viewState changed: \(viewState.description)")
                    guard let self else { return }
                    // Prevent inconsistent view states
                    switch viewState {
                    case .initialLoad, .empty:
                        self.resetState()
                    case .inError(let error, let retry):
                        self.error = error
                        self.showError = true
                        self.errorAllowsRetry = retry
                    case .loaded(let newArtworks, let lastPage):
                        if shouldDiscardOldData {
                            self.artworks = OrderedSet(newArtworks)
                        } else {
                            var artworks = self.artworks
                            artworks.append(contentsOf: newArtworks)
                            self.artworks = artworks
                        }
                        self.lastPage = lastPage
                        self.shouldLoadMore = lastPage.nextUrl != nil
                        self.shouldDiscardOldData = false
                    }
                })
                .store(in: &cancellables)
        }
        
        private func resetState() {
            self.artworks = []
            self.lastPage = nil
            self.shouldLoadMore = false
            self.error = nil
            self.showError = false
            self.errorAllowsRetry = false
        }
    }
}

extension ArtworkList {
    enum ViewState: Equatable, CustomStringConvertible {
        case empty
        case initialLoad
        case loaded(artworks: [Artwork], lastPage: Pagination)
        case inError(Error, retry: Bool)
        
        var description: String {
            switch self {
            case .empty:
                return "empty"
            case .initialLoad:
                return "initialLoad"
            case .loaded(let artworks, let page):
                return "loaded page: \(page.currentPage) count: \(artworks.count)"
            case .inError(let error, let retry):
                return "inError(\(error.localizedDescription), retry: \(retry))"
            }
        }
        
        static func == (lhs: ArtworkList.ViewState, rhs: ArtworkList.ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.empty, .empty):
                return true
            case (.initialLoad, .initialLoad):
                return true
            case (.loaded(let lhsArtworks, let lhsPage), .loaded(let rhsArtworks, let rhsPage)):
                return lhsArtworks == rhsArtworks && lhsPage == rhsPage
            case (.inError(let lhsError, let lhsRetry), .inError(let rhsError, let rhsRetry)):
                let equalErrors = lhsError.localizedDescription == rhsError.localizedDescription
                let equalRetry = lhsRetry == rhsRetry
                return equalErrors && equalRetry
            default:
                return false
            }
        }
    }
}

extension ArtworkList {
    final class Coordinator: ObservableObject, ViewCoordinator, Loggable {
        private var dataModel: DataModel
        private weak var repository: (any ArtworkRepositoryProtocol)?
        
        init(
            dataModel: DataModel,
            repository: (any ArtworkRepositoryProtocol)?
        ) {
            self.repository = repository
            self.dataModel = dataModel
            
            if case .empty = self.dataModel.viewState {
                Task { @MainActor in
                    self.dataModel.viewState = .initialLoad
                    do {
                        try await self.perform(action: .loadArtworks(page: self.dataModel.lastPage))
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
            .navigationTitle("Artworks")
        }
        
        @MainActor
        public func perform(action: Actions) async throws {
            switch action {
            case .loadArtworks(let page):
                log("loading artworks")
                guard let response = try await self.repository?.loadArtworks(page: page) else {
                    log("uh-oh, no repository")
                    return
                }
                let (newArtworks, page) = response
                log("retrieved artworks: \(newArtworks.count)")
                self.dataModel.viewState = .loaded(artworks: newArtworks, lastPage: page)
                self.preheatNextPage(page)
            case .refreshArtworks:
                log("refreshing artworks")
                guard let response = try await self.repository?.loadArtworks() else {
                    log("uh-oh, no repository")
                    return
                }
                let (newArtworks, page) = response
                log("retrieved artworks: \(newArtworks.count)")
                self.dataModel.shouldDiscardOldData = true
                self.dataModel.viewState = .loaded(artworks: newArtworks, lastPage: page)
                self.preheatNextPage(page)
            }
        }
        
        // Preheat is not an Action to now be exposed to the view
        private func preheatNextPage(_ page: Pagination) {
            log("page: \(page.currentPage + 1)")
            guard dataModel.shouldLoadMore else {
                log("last page already loaded...")
                return
            }
            guard let repository else {
                log("uh-oh, no repository")
                return
            }
            Task {
                try? await repository.loadArtworks(page: page)
            }
        }
    }
}

extension ArtworkList {
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
            artworkList
            .overlay {
                if case .initialLoad = self.dataModel.viewState {
                    ProgressView()
                }
            }
            .alert(
                "Ooops, something went wrong",
                isPresented: self.$dataModel.showError,
                presenting: self.dataModel.error,
                actions: { error in
                    if self.dataModel.errorAllowsRetry {
                        Button("Retry") {
                            self.perform(action: .loadArtworks(page: self.dataModel.lastPage))
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {
                        self.dismissError()
                    }
            })
            .refreshable {
                // refreshable is already creating a async Task, so only here we want to duplicate
                // this logic to avoid problems with a Task inside another Task
                log("perform action refresh")
                do {
                    try await self.actionHandler(.refreshArtworks)
                } catch {
                    self.handleError(error)
                }
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

private extension ArtworkList.ContentView {
    @ViewBuilder
    var artworkList: some View {
        List {
            artworkItemsView(self.dataModel.artworks)
            loadMorePagesView
        }
    }
    
    @ViewBuilder
    func artworkItemsView(_ artworks: OrderedSet<Artwork>) -> some View {
        ForEach(artworks, id: \.id) { artwork in
            NavigationLink(value: artwork) {
                ArtworkListItem(artwork: artwork)
            }
        }
    }
    
    @ViewBuilder
    var loadMorePagesView: some View {
        // Load more items if not last page.
        if self.dataModel.shouldLoadMore {
            Text("Loading...")
                .onAppear {
                    self.perform(action: .loadArtworks(page: self.dataModel.lastPage))
                }
        }
    }
}
