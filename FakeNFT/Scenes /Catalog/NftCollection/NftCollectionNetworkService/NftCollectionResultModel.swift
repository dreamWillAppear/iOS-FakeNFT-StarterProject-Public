import Foundation

struct NftCollectionResultModel: Decodable {
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    
    var nftCount: Int {
        nfts.count
    }
}
