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
    
    func updateCart(nftsIds: [String], currentCartData: NftCartResultModel, completion: @escaping NftCartCompletion) {
        var bodyString = ""
        
        if !nftsIds.isEmpty {
            nftsIds.forEach { nftId in
                bodyString += "&nfts=\(nftId)"
            }
        } else {
            bodyString += "&nfts=null"
        }
        
        guard let bodyData = bodyString.data(using: .utf8),
              let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NSError(domain: "No data received", code: 1002)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NftCartResultModel.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
