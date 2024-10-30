import Foundation

struct NftCollectionCellRequest: NetworkRequest {
    var id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    
    var dto: (any Dto)?
}
