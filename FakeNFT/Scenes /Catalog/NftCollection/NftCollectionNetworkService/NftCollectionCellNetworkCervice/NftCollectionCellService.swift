import Foundation

typealias NftCollectionCellCompletion = (Result<NftCollectionCellResultModel, Error>) -> Void

protocol NftCollectionCellServiceProtocol {
    func loadNftCollection(completion: @escaping NftCollectionCellCompletion)
}

final class NftCollectionCellService: NftCollectionCellServiceProtocol {
    private let id: String
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient, id: String) {
        self.networkClient = networkClient
        self.id = id
    }
    
    func loadNftCollection(completion: @escaping NftCollectionCellCompletion) {
        let request = NftCollectionCellRequest(id: id)
        networkClient.send(request: request, type: NftCollectionCellResultModel.self, onResponse: completion)
    }
    
}
