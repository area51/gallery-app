import Foundation
import ArticClient

struct PaginationMapper {
    
    /// Maps `PaginationDTO` to `Pagination`.
    /// - parameter dto: The data transfer object to be mapped.
    /// - returns: The mapped `Pagination` object.
    static func map(dto: PaginationDTO) -> Pagination {
        Pagination(
            total: dto.total,
            limit: dto.limit,
            offset: dto.offset,
            totalPages: dto.totalPages,
            currentPage: dto.currentPage,
            nextUrl: dto.nextUrl
        )
    }
}
