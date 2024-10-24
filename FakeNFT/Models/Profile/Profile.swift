//
//  Profile.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

struct Profile: Codable {
    let name: String
    let avatar: String
    let rating: String
    let description: String
    let website: String
    let id: String
    let nfts: [String]
}
