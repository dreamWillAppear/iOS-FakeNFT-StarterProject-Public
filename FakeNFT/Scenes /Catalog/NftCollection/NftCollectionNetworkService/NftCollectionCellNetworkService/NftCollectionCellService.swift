import Foundation

typealias NftCollectionCellCompletion = (Result<NftCollectionCellResultModel, Error>) -> Void

protocol NftCollectionCellServiceProtocol {
    func loadNftCollection(id: String, completion: @escaping NftCollectionCellCompletion)
}

final class NftCollectionCellService: NftCollectionCellServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftCollection(id: String, completion: @escaping NftCollectionCellCompletion) {
        let request = NftCollectionCellRequest(id: id)
        networkClient.send(request: request, type: NftCollectionCellResultModel.self, onResponse: completion)
    }
    
}
