//
//  NFTService.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 01.11.2024.
//

import Foundation

final class NFTService {
    
    func fetchNFT(withID nftID: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        let urlString = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(nftID)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL for NFT ID \(nftID)")
            return completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
            }

            // Print response data as a string to debug
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON for NFT \(nftID): \(jsonString)")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let name = json["name"] as? String,
                   let images = json["images"] as? [String],
                   let rating = json["rating"] as? Int,
                   let author = json["name"] as? String,
                   let price = json["price"] as? Float,
                   let id = json["id"] as? String {
                    
                    let nft = NFT(
                        imageName: images.first ?? "",
                        likeImageName: "notLiked",
                        name: self.extractNFTName(from: images.first ?? "") ?? name,
                        ratingImageName: "\(rating)",
                        author: "от \(author)",
                        price: "\(price) ETH",
                        id: id
                    )
                    completion(.success(nft))
                } else {
                    throw NSError(domain: "InvalidJSON", code: -1, userInfo: nil)
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func extractNFTName(from urlString: String) -> String? {
        let pattern = #"\/([^\/]+)\/\d+\.png$"#
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        )
        let nsString = urlString as NSString
        let results = regex?.firstMatch(
            in: urlString,
            options: [],
            range: NSRange(
                location: 0,
                length: nsString.length
            )
        )
        
        if let range = results?.range(
            at: 1
        ) {
            return nsString.substring(
                with: range
            )
        }
        return nil
    }
}
