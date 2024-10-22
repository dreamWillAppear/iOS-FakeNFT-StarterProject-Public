//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import Foundation

protocol CartViewPresenterProtocol {
    func getDataNft() -> [NftCart]
}

final class CartViewPresenter: CartViewPresenterProtocol {
    
    private let data = CartEnum.cart
    
    func getDataNft() -> [NftCart] {
        return data
    }
}
