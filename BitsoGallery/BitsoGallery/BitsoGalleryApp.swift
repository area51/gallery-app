import SwiftUI
import AppCore
import Presentation

@main
struct BitsoGalleryApp: App {
    @StateObject var app: Application
    
    init() {
        let app = Application(
            repository: RepositoryFactory.make()
        )
        self._app = StateObject(wrappedValue: app)
    }
    
    var body: some Scene {
        WindowGroup {
            self.app.contentView
        }
    }
}
