import Foundation

typealias NftLikesCompletion = (Result<NftLikesResultModel, Error>) -> Void

protocol NftLikesServiceProtocol {
    func loadNftLikes(completion: @escaping NftLikesCompletion)
}

final class NftLikesService: NftLikesServiceProtocol {

    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftLikes(completion: @escaping NftLikesCompletion) {
        let request = NftLikesGetRequest()
        networkClient.send(request: request, type: NftLikesResultModel.self, onResponse: completion)
    }

}


