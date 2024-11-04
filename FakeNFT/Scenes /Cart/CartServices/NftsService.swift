//
//  NftService.swift
//  FakeNFT
//
//  Created by Konstantin on 30.10.2024.
//

import Foundation

final class NftsService {
    
    static let shared = NftsService()
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "NftProviderDidChange")
    
    var arrayOfNfts: [NftResult] = []
    
    private init() {}
    
    private func makeNftRequest(idNft: String) -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(idNft)") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: headerForToken)

        request.httpMethod = "GET"
        return request
    }
    
    func fetchNft(idfNft: String, completion: @escaping (Result<NftResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let request = makeNftRequest(idNft: idfNft) else {
            return 
        }
        let task = urlSession.cartObjectTask(for: request) { [weak self] (result: Result<NftResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    self.arrayOfNfts.append(decodedData)
                    DispatchQueue.main.async {
                        NotificationCenter.default
                            .post(name: NftsService.didChangeNotification,
                                    object: self,
                                    userInfo: ["URL": decodedData])
                    }
                    
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                    print("[ProfileService]: \(error)")
                }
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func fetchNfts(idsfNft: [String], completion: @escaping (Result<NftResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        for id in idsfNft {
            DispatchQueue.main.async {
                guard let request = self.makeNftRequest(idNft: id) else { return }
                let task = self.urlSession.cartObjectTask(for: request) { [weak self] (result: Result<NftResult, Error>) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let decodedData):
                            self.arrayOfNfts.append(decodedData)
                            DispatchQueue.main.async {
                                NotificationCenter.default
                                    .post(name: CartService.didChangeNotification,
                                            object: self,
                                            userInfo: ["URL": decodedData])
                            }
                            
                            completion(.success(decodedData))
                        case .failure(let error):
                            completion(.failure(error))
                            print("[ProfileService]: \(error)")
                        }
                    }
                    self.task = nil
                }
                self.task = task
                task.resume()
            }
        }
    }
}
