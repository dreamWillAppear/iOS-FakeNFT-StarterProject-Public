//
//  CartService.swift
//  FakeNFT
//
//  Created by Konstantin on 30.10.2024.
//

import Foundation

final class CartService {
    
    var cartInfo: CartResult?
    
    static let shared = CartService()
    
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "CartProviderDidChange")

    private init() {}
    
    private func makeCartRequest() -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: headerForToken)

        request.httpMethod = "GET"
        return request
    }
    
    func fetchCart(completion: @escaping (Result<CartResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let request = makeCartRequest() else { return }
        let task = urlSession.cartObjectTask(for: request) { [weak self] (result: Result<CartResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    self.cartInfo = decodedData
                    DispatchQueue.main.async {
                        self.task = nil
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
