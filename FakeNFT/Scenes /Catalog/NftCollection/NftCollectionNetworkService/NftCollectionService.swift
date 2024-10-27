import Foundation

typealias NftCollectionCompletion = (Result<NftCollectionResultModel, Error>) -> Void

protocol NftCollectionServiceProtocol {
    var id: String { get set }
    func loadNftCollection(completion: @escaping NftCollectionCompletion)
}

final class NftCollectionService: NftCollectionServiceProtocol {
    
    var id: String

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient, id: String) {
        self.networkClient = networkClient
        self.id = id
    }
    
    func loadNftCollection(completion: @escaping NftCollectionCompletion) {
        let request = NftCollectionRequest(id: id)
        networkClient.send(request: request, type: NftCollectionResultModel.self, onResponse: completion)
    }

}


