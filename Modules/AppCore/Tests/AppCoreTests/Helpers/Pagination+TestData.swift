import Foundation
import AppCore
import ArticClient

extension Pagination {
    static var firstPage: Pagination {
        Pagination(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 1,
            nextUrl: nil
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

extension PaginationDTO {
    static var firstPage: PaginationDTO {
        PaginationDTO(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 1,
            nextUrl: nil
        )
    }
    
    static var lastPage: PaginationDTO {
        PaginationDTO(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 10,
            nextUrl: nil
        )
    }
}
