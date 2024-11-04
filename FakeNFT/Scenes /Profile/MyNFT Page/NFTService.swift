//
//  NFTService.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 01.11.2024.
//

import Foundation

final class NFTService {
    
    static let shared = NFTService()
    private let token = "69a72b9d-5370-4d97-9593-9c27f9eb3d0a"
    private let headerForToken = "X-Practicum-Mobile-Token"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    var arrayOfNfts: [NFT] = []
    
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
    
    func fetchNfts(idsfNft: [String], completion: @escaping (Result<NFT, Error>) -> Void) {
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
    
//    func fetchNFT(withID nftID: String, completion: @escaping (Result<NFT, Error>) -> Void) {
//        let urlString = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(nftID)"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL for NFT ID \(nftID)")
//            return completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                return completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
//            }
//
//            // Print response data as a string to debug
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON for NFT \(nftID): \(jsonString)")
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let name = json["name"] as? String,
//                   let images = json["images"] as? [String],
//                   let rating = json["rating"] as? Int,
//                   let author = json["name"] as? String,
//                   let price = json["price"] as? Float,
//                   let id = json["id"] as? String {
//                    
//                    let nft = NFT(
//                        imageName: images.first ?? "",
//                        likeImageName: "notLiked",
//                        name: self.extractNFTName(from: images.first ?? "") ?? name,
//                        ratingImageName: "\(rating)",
//                        author: "от \(author)",
//                        price: "\(price) ETH",
//                        id: id
//                    )
//                    completion(.success(nft))
//                } else {
//                    throw NSError(domain: "InvalidJSON", code: -1, userInfo: nil)
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func extractNFTName(from urlString: String) -> String? {
//        let pattern = #"\/([^\/]+)\/\d+\.png$"#
//        let regex = try? NSRegularExpression(
//            pattern: pattern,
//            options: []
//        )
//        let nsString = urlString as NSString
//        let results = regex?.firstMatch(
//            in: urlString,
//            options: [],
//            range: NSRange(
//                location: 0,
//                length: nsString.length
//            )
//        )
//        
//        if let range = results?.range(
//            at: 1
//        ) {
//            return nsString.substring(
//                with: range
//            )
//        }
//        return nil
//    }
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
