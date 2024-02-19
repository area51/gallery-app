import Foundation
@testable import ArticClient

extension ArtworkResponse.Get: Encodable {
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(pagination, forKey: .pagination)
    }
}
