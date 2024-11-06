//
//  NFT.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

struct NFT: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
