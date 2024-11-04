//
//  extension+cartObjectTask.swift
//  FakeNFT
//
//  Created by Konstantin on 30.10.2024.
//

import Foundation

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
