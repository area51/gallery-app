import Foundation
import ArticClient

extension PaginationDTO {
    static var firstPage: PaginationDTO {
        PaginationDTO(
            total: 120,
            limit: 12,
            offset: 0,
            totalPages: 10,
            currentPage: 1,
            nextUrl: URL(string: "https://api.area51.com/artworks?page=2")!
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
