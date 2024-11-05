import Foundation

struct NftCollectionRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
    
    var dto: (any Dto)?
}
