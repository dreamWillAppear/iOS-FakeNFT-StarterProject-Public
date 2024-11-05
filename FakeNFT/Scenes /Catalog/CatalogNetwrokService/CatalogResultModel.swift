import Foundation

struct CatalogResultModel: Decodable {
    let name: String
    let cover: String
    let id: String
    let nfts: [String]
    
    var nftCount: Int {
        nfts.count
    }
}
