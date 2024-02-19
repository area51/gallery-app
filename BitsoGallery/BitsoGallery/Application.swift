import SwiftUI
import Presentation
import AppCore

class Application: ObservableObject {
    var repository: RepositoryProtocol
    lazy var contentCoordinator = ContentCoordinator(
        repository: self.repository
    )
    
    @Published var state: AppState
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        
        self.state = .loggedIn
    }
    
    @ViewBuilder var contentView: some View {
        switch self.state {
        default:
            self.contentCoordinator.contentView
        }
    }
    
    enum AppState {
        // This is not needed for this app, but is a nice template to leave
        // in case this was going to grow and became a real app some global actions would be
        // handy
        case gallery
        case loggedIn
        case loggedOut
        case initializing
    }
}
