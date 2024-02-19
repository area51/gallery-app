import Foundation

protocol ViewCoordinator {
    associatedtype Content
    var contentView: Content { get }
    
    associatedtype Actions
    func perform(action: Actions) async throws
}
