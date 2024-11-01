//
//  CartEnum.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

enum MokeEnum {
    static let cart: [NftCart] = [
        NftCart(name: "April", image: UIImage(named: "moke1") ?? UIImage(), grade: 1, price: 1.78),
        NftCart(name: "Greena", image: UIImage(named: "moke2") ?? UIImage(), grade: 3, price: 1.78),
        NftCart(name: "Spring", image: UIImage(named: "moke3") ?? UIImage(), grade: 5, price: 1.78)
    ]
    
    static let payment: [Payment] = [
        Payment(image: UIImage(named: "p1") ?? UIImage(), fullName: "Bitcoin", shortName: "BTC"),
        Payment(image: UIImage(named: "p2") ?? UIImage(), fullName: "Dogecoin", shortName: "DOGE"),
        Payment(image: UIImage(named: "p3") ?? UIImage(), fullName: "Tether", shortName: "USDT"),
        Payment(image: UIImage(named: "p4") ?? UIImage(), fullName: "Apecoin", shortName: "APE"),
        Payment(image: UIImage(named: "p5") ?? UIImage(), fullName: "Solana", shortName: "SOL"),
        Payment(image: UIImage(named: "p6") ?? UIImage(), fullName: "Ethereum", shortName: "ETH"),
        Payment(image: UIImage(named: "p7") ?? UIImage(), fullName: "Cardano", shortName: "ADA"),
        Payment(image: UIImage(named: "p8") ?? UIImage(), fullName: "Shiba Inu", shortName: "SHIB"),
    ]
}
