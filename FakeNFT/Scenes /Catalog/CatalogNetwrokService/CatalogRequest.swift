//struct NFTRequest: NetworkRequest {
//    let id: String
//    var endpoint: URL? {
//        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
//    }
//    var dto: Dto?
//}

import Foundation

struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    
    var dto: (any Dto)?
}
