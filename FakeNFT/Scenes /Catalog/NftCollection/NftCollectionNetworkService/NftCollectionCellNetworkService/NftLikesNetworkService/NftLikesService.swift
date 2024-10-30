import Foundation

typealias NftLikesCompletion = (Result<NftLikesResultModel, Error>) -> Void

protocol NftLikesServiceProtocol {
    func loadNftLikes(completion: @escaping NftLikesCompletion)
    func updateLikes(nftsIds: [String], currentProfileData: NftLikesResultModel, completion: @escaping NftLikesCompletion)
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
    
    func updateLikes(nftsIds: [String], currentProfileData: NftLikesResultModel, completion: @escaping NftLikesCompletion) {
        var bodyString = "name=\(currentProfileData.name)&description=\(currentProfileData.description)&website=\(currentProfileData.website)"
        
        if !nftsIds.isEmpty {
            nftsIds.forEach { likeId in
                bodyString += "&likes=\(likeId)"
            }
        } else {
            bodyString += "&likes=null"
        }
        
        guard let bodyData = bodyString.data(using: .utf8),
              let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                let result = try decoder.decode(NftLikesResultModel.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
