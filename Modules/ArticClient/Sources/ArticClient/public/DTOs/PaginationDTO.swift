import Foundation

/// DTO for the pagination
public struct PaginationDTO: Codable, Equatable {
    public let total: Int
    public let limit: Int
    public let offset: Int
    public let totalPages: Int
    public let currentPage: Int
    public let nextUrl: URL?
    
    /// Initializes the PaginationDTO.
    /// Mostly a convinience initializer for testing.
    /// - parameter total: The total number of items
    /// - parameter limit: The limit of items per page
    /// - parameter offset: The offset of the current page
    /// - parameter totalPages: The total number of pages
    /// - parameter currentPage: The current page
    /// - parameter nextUrl: The next page URL
    public init(
        total: Int,
        limit: Int,
        offset: Int,
        totalPages: Int,
        currentPage: Int,
        nextUrl: URL?
    ) {
        self.total = total
        self.limit = limit
        self.offset = offset
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.nextUrl = nextUrl
    }
}
