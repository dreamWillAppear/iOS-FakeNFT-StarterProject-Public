import Foundation

typealias CatalogCompletion = (Result<[CatalogResultModel], Error>) -> Void

protocol CatalogServiceProtocol {
    func loadCollections(completion: @escaping CatalogCompletion )
}

final class CatalogService: CatalogServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    
    func loadCollections(completion: @escaping CatalogCompletion) {
        let request = CatalogRequest()
        networkClient.send(request: request, type: [CatalogResultModel].self ) { result in
            
            switch result {
                case .success(let result):
                    completion(.success(result))
                case.failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

