//
//  NFTService.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 01.11.2024.
//

import Foundation

final class NFTService {
    
    static let shared = NFTService()
    private let header = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    var arrayOfNfts: [NFT] = []
    
    private init() {}
    
    private func makeNftRequest(idNft: String) -> URLRequest? {
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(idNft)") else {
            preconditionFailure("Error: cant construct url")
        }
        var request = URLRequest(url: url)
        request.setValue(RequestConstants.token, forHTTPHeaderField: header)

        request.httpMethod = "GET"
        return request
    }
    
    func fetchNfts(idsfNft: [String], completion: @escaping (Result<NFT, Error>) -> Void) {
        arrayOfNfts.removeAll()
        UIProfileBlockingProgressHUD.show()
        assert(Thread.isMainThread)
        guard task == nil else { return }
        for id in idsfNft {
            DispatchQueue.main.async {
                guard let request = self.makeNftRequest(idNft: id) else { return }
                let task = self.urlSession.cartObjectTask(for: request) { [weak self] (result: Result<NFT, Error>) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let decodedData):
                            self.arrayOfNfts.append(decodedData)
                            completion(.success(decodedData))
                            UIProfileBlockingProgressHUD.dismiss()
                        case .failure(let error):
                            completion(.failure(error))
                            print("[NFTService]: \(error)")
                            UIProfileBlockingProgressHUD.dismiss()
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

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decoderError(Error)
}

extension URLSession {
    func cartObjectTask<T: Codable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in  // 2
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let decoder = JSONDecoder()
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decodedData = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(decodedData))
                    }
                    catch {
                        print("\(String(describing: T.self)) [dataTask:] - Error of decoding: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.decoderError(error)))
                    }
                } else {
                    print("\(String(describing: T.self)) [dataTask:] - Network Error \(statusCode)" )
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    return
                }
            } else if let error = error {
                print("\(String(describing: T.self)) [URLRequest:] - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print("Error: urlSessionError")
                return
            }
        })
        
        return task
    }
}
