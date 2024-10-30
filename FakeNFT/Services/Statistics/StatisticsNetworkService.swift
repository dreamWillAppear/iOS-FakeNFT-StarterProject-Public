//
//  StatisticsNetworkService.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import Foundation

final class StatisticNetworkServise {
    private let url: String = NetworkConstants.baseURL
    private let token: String = NetworkConstants.token
    
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
    
    func updateCart(ids: CartOrder, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkConstants.put
        request.setValue(NetworkConstants.acceptValue, forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(NetworkConstants.token, forHTTPHeaderField: NetworkConstants.requestHeader)
        request.setValue(NetworkConstants.putValue, forHTTPHeaderField: NetworkConstants.putHeader)
        if !ids.nfts.isEmpty {
            let nftsString = ids.nfts.joined(separator: ",")
            let bodyString = "nfts=\(nftsString)"
            guard let bodyData = bodyString.data(using: .utf8) else { return }
            request.httpBody = bodyData
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    DispatchQueue.main.async {
                        completion(.success(()))
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
    
    func fetchCart(completion: @escaping (Result<CartOrder, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkConstants.get
        request.setValue(NetworkConstants.acceptValue, forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(self.token, forHTTPHeaderField: NetworkConstants.requestHeader)
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
                    let nfts = try decoder.decode(CartOrder.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nfts))
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
    
    func fetchFavourites(completion: @escaping (Result<FavoutiteNft, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/profile/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkConstants.get
        request.setValue("application/json", forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(self.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
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
                    let nfts = try decoder.decode(FavoutiteNft.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(nfts))
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
    
    func updateFavourites(ids: FavoutiteNft, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(self.url)/api/v1/profile/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkConstants.put
        request.setValue(NetworkConstants.acceptValue, forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(self.token, forHTTPHeaderField: NetworkConstants.requestHeader)
        request.setValue(NetworkConstants.putValue, forHTTPHeaderField: NetworkConstants.putHeader)
        if !ids.likes.isEmpty {
            let nftsString = ids.likes.joined(separator: ",")
            let bodyString = "likes=\(nftsString)"
            guard let bodyData = bodyString.data(using: .utf8) else { return }
            request.httpBody = bodyData
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    DispatchQueue.main.async {
                        completion(.success(()))
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
