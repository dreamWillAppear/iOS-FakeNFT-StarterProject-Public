import Foundation

typealias NftCollectionCompletion = (Result<NftCollectionResultModel, Error>) -> Void

protocol NftCollectionServiceProtocol {
    func loadNftCollection(id: String, completion: @escaping NftCollectionCompletion)
}

final class NftCollectionService: NftCollectionServiceProtocol {
    
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftCollection(id: String, completion: @escaping NftCollectionCompletion) {
        let request = NftCollectionRequest(id: id)
        networkClient.send(request: request, type: NftCollectionResultModel.self, onResponse: completion)
    }
    
}


