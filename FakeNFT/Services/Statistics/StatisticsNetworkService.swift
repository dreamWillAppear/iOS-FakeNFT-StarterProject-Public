//
//  StatisticsNetworkService.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import Foundation


struct Profile: Codable {
    let name: String
    let avatar: String
    let rating: String
    let description: String
    let website: String
    let id: String
    let nfts: [String]
}


final class StatisticNetworkServise {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let url: String = NetworkConstants.baseURL
    private let token: String = NetworkConstants.token
    
    // MARK: - Public Methods
    func fetchUsers(completion: @escaping (Result<[Profile], Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/users") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let users = try decoder.decode([Profile].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(users))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
    
    func fetchNft(id: String, completion: @escaping (Result<NftInfo, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/nft/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let nft = try decoder.decode(NftInfo.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nft))
                    }
                } catch let parsingError {
                    DispatchQueue.main.async {
                        completion(.failure(parsingError))
                    }
                }
            } else {
                let httpResponse = response as? HTTPURLResponse
                let statusCodeError = NSError(domain: "", code: httpResponse?.statusCode ?? 500, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(statusCodeError))
                }
            }
        }
        task.resume()
    }
}
