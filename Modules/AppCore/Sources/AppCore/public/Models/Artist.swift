import Foundation

/// Artist business object
public struct Artist: Identifiable, Hashable {
    public let id: Int
    public let title: String
    public let birthDate: Int?
    public let deathDate: Int?
    public let description: String?
    
    /// Initializes a new instance of the `Artist` struct.
    /// - parameter id: The unique identifier of the artist.
    /// - parameter title: The title of the artist.
    /// - parameter birthDate: The birth date of the artist. Default value is `nil`.
    /// - parameter deathDate: The death date of the artist. Default value is `nil`.
    /// - parameter description: The description of the artist. Default value is `nil`.
    public init(
        id: Int,
        title: String,
        birthDate: Int? = nil,
        deathDate: Int? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.title = title
        self.birthDate = birthDate
        self.deathDate = deathDate
        self.description = description
    }
    
    /// Hashes the essential components of the object.
    /// Just for convinience to already have it in all objects and also gain `Equatable` conformance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
