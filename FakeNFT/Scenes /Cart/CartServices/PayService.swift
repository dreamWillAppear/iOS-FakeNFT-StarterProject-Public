//
//  PayService.swift
//  FakeNFT
//
//  Created by Konstantin on 01.11.2024.
//

import Foundation

final class PayService {
    
    static let shared = PayService()
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
  
    private init() {}
    
    private func makePayRequest(paymentId: String) -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1/payment/\(paymentId)") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: headerForToken)

        request.httpMethod = "GET"
        return request
    }
    
    func fetchPay(paymentId: String, completion: @escaping (Result<PayResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let request = makePayRequest(paymentId: paymentId) else { return }
        let task = urlSession.cartObjectTask(for: request) { [weak self] (result: Result<PayResult, Error>) in
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

