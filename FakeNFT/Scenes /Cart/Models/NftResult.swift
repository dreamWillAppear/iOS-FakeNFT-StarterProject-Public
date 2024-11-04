//
//  File.swift
//  FakeNFT
//
//  Created by Konstantin on 30.10.2024.
//

import Foundation

struct NftResult: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
