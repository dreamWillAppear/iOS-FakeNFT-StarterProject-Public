//
//  DeleteService.swift
//  FakeNFT
//
//  Created by Konstantin on 01.11.2024.
//

import Foundation

final class DeleteService {
    
    static let shared = DeleteService()
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?

    private init() {}
    
    private func makeDeleteRequest(order: CartResult, deletetedNft: String) -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else {
            preconditionFailure("Error: cant construct url")
        }
        var newOrder = order
        for i in 0..<order.nfts.count {
            if order.nfts[i] == deletetedNft {
                var newNfts = order.nfts
                newNfts.remove(at: i)
                let newId = order.id
                newOrder = CartResult(nfts: newNfts, id: newId)
            }
        }
        var parameters = ""
        for nft in newOrder.nfts {
            parameters += "nfts=\(nft)&"
        }
        parameters += "id=\(newOrder.id)"
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: headerForToken)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = postData
        return request
    }
    
    func fetchPayment(order: CartResult, deletetedNft: String, completion: @escaping (Result<CartResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let request = makeDeleteRequest(order: order, deletetedNft: deletetedNft) else { return }
        let task = urlSession.cartObjectTask(for: request) { [weak self] (result: Result<CartResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    DispatchQueue.main.async {
                        self.task = nil
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
