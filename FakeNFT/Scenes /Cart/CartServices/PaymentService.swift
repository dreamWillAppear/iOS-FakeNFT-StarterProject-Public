//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Konstantin on 31.10.2024.
//

import Foundation

final class PaymentService {
    
    static let shared = PaymentService()
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var paymentInfo: [PaymentResult] = []
    
    static let didChangeNotification = Notification.Name(rawValue: "PaymentProviderDidChange")
        
    private init() {}
    
    private func makePaymentRequest() -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/currencies") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: headerForToken)

        request.httpMethod = "GET"
        return request
    }
    
    func fetchPayment(completion: @escaping (Result<[PaymentResult], Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        guard let request = makePaymentRequest() else { return }
        let task = urlSession.cartObjectTask(for: request) { [weak self] (result: Result<[PaymentResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let decodedData):
                    self.paymentInfo = decodedData
                    DispatchQueue.main.async {
                        self.task = nil
                        NotificationCenter.default
                            .post(name: PaymentService.didChangeNotification,
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
