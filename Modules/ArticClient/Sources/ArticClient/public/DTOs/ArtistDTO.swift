import Foundation

/// DTO for the Artist
public struct ArtistDTO: Codable, Equatable {
    public let id: Int
    public let title: String
    public let birthDate: Int?
    public let deathDate: Int?
    public let description: String?
    
    /// Initializes the ArtistDTO.
    /// Mostly a convinience initializer for testing.
    /// - parameter id: The artist id
    /// - parameter title: The artist name
    /// - parameter birthDate: The artist birth date
    /// - parameter deathDate: The artist death date
    /// - parameter description: The artist description
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
}
