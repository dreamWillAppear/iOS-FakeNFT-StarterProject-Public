//
//  CartEnum.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

enum CartEnum {
    static let cart: [NFTCart] = [
        NFTCart(name: "April", image: UIImage(named: "moke1") ?? UIImage(), grade: 1, price: 1.78),
        NFTCart(name: "Greena", image: UIImage(named: "moke2") ?? UIImage(), grade: 3, price: 1.78),
        NFTCart(name: "Spring", image: UIImage(named: "moke3") ?? UIImage(), grade: 5, price: 1.78)
    ]
}
