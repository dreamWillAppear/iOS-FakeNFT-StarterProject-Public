//
//  NFT.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//
import Foundation
struct NftInfo: Codable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let id: String
}
