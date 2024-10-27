import Foundation

struct NftCollectionCellRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
    
    var dto: (any Dto)?
}
