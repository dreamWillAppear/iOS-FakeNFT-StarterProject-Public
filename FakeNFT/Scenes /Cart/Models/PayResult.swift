//
//  PayResult.swift
//  FakeNFT
//
//  Created by Konstantin on 01.11.2024.
//

import Foundation

struct PayResult: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
