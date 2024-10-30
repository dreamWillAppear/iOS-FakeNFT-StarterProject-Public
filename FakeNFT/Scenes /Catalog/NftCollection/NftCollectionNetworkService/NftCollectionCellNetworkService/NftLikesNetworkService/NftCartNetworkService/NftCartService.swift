import Foundation

typealias NftCartCompletion = (Result<NftCartResultModel, Error>) -> Void

protocol NftCartServiceProtocol {
    func loadNftInCart(completion: @escaping NftCartCompletion)
}

final class NftCartService: NftCartServiceProtocol {

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftInCart(completion: @escaping NftCartCompletion) {
        let request = NftCartGetRequest()
        networkClient.send(request: request, type: NftCartResultModel.self, onResponse: completion)
    }
    
}


