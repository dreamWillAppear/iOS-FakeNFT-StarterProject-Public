//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import Foundation

protocol CartViewPresenterProtocol {
    var view: CartViewControllerProtocol?{ get set }
    var cardData: CartResult? { get set }
    func getNfts() -> [NftResult]
    func getIdNfts() -> [String]?
    func fetchCart()
    func getOrder() -> CartResult?
    func deleteCash()
    func sortByPrice()
    func sortByRating()
    func sortByName()
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
        UICartBlockingProgressHUD.show()
        cartService.fetchCart() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let decodedData):
                self.cardData = decodedData
                if decodedData.nfts.isEmpty {
                    view?.orderOfNftIsEmpty(orderIsEmpty: true)
                } else {
                    view?.orderOfNftIsEmpty(orderIsEmpty: false)
                }
                nftsService.fetchNfts(idsfNft: decodedData.nfts) { [weak self] resultNft in
                    guard let self = self else { return }
                    switch resultNft {
                    case .success(_):
                        print(self.nftsService.arrayOfNfts)
                    case .failure(_):
                        print("WWWWW")
                    }
                }
                UICartBlockingProgressHUD.dismiss()
            case .failure(_):
                print("fail cart")
            }
        }
    }
    
    func getNfts() -> [NftResult] {
        return nftsService.arrayOfNfts
    }
    
    func getIdNfts() -> [String]? {
        return cardData?.nfts
    }
    
    func getOrder() -> CartResult? {
        return cardData
    }
    
    func deleteCash() {
        nftsService.arrayOfNfts = []
        cartService.cartInfo = nil
        cardData = nil
    }
    
    func sortByPrice() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.price > value2.price
        }
        view?.arrayOfNfts = sortedNfts
    }
    
    func sortByRating() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.rating > value2.rating
        }
        view?.arrayOfNfts = sortedNfts
    }
    
    func sortByName() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.name < value2.name
        }
        view?.arrayOfNfts = sortedNfts
    }
}
