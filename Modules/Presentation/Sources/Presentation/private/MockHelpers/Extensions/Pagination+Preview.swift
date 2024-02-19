import Foundation
import AppCore

extension Pagination {
    static var firstPage: Pagination {
        Pagination(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 1,
            nextUrl: URL(string: "https://artworks.area51.com/nextPage")
        )
    }
    
    static var lastPage: Pagination {
        Pagination(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 10,
            nextUrl: nil
        )
    }
}
