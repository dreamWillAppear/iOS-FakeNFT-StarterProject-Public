//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import Foundation
import ProgressHUD

protocol CartViewPresenterProtocol {
    var view: CartViewControllerProtocol?{ get set }
    var cardData: CartResult? { get set }
    
    func fetchCart()

}

final class CartViewPresenter: CartViewPresenterProtocol {

    var view: CartViewControllerProtocol?

    private let cartService = CartService.shared
    private let nftsService = NftsService.shared
  
    var cardData: CartResult?
    var nftsData: [NftResult]?
    
    init(view: CartViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func fetchCart() {
        ProgressHUD.animate()
        cartService.fetchCart() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let decodedData):
                print(decodedData)
                self.cardData = decodedData
                nftsService.fetchNfts(idsfNft: decodedData.nfts) { resultNft in
                    switch resultNft {
                    case .success(let nftModel):
                        print(self.nftsService.arrayOfNfts)
                    case .failure(_):
                        print("WWWWW")
                    }
                }
                ProgressHUD.dismiss()
            case .failure(_):
                print("fail cart")
            }
        }
    }
}
