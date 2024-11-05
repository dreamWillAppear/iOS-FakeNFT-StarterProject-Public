//
//  NFTStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//
import Foundation

struct CartOrder: Codable {
    let nfts: [String]
}

struct FavoutiteNft: Codable {
    var likes: [String]
}

final class NFTStore {
    let statisticsService = StatisticNetworkServise()
    
    private let nftIndexes: [String]
    private var nftList: [NftInfo] = []
    
    private var nftInCart: [String] = []
    private var favoutiteNfts: [String] = []
    
    init(nftIndexes: [String]) {
        self.nftIndexes = nftIndexes
    }
    
    func getCartList() -> [String] {
        nftInCart
    }
    
    func getFavouriteList() -> [String] {
        favoutiteNfts
    }
    
    func fetch(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        fetchNfts(nftIndexes: nftIndexes, completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    func reloadCart(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        fetchCart(completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    func reloadFavourites(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        fetchFavourites(completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    func updateFavouriteByNft(nfts: FavoutiteNft, completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        updateFavoutite(nft: nfts, completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    func updateCartByNft(nfts: CartOrder, completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        updateCart(nft: nfts, completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    private func fetchNfts(nftIndexes: [String], completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        let group = DispatchGroup()
        for index in nftIndexes {
            group.enter()
            statisticsService.fetchNft(id: index) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nftList.append(nft)
                    group.leave()
                case .failure:
                    completionOnFailure()
                    group.leave()
                    break
                }
            }
        }
        group.notify(queue: .main) {
            completionOnSuccess()
        }
    }
    
    private func updateFavoutite(nft: FavoutiteNft, completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void ) {
        statisticsService.updateFavourites(ids: nft) { [weak self] result in
            switch result {
            case .success(let result):
                self?.fetchFavourites(completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
            case .failure:
                completionOnFailure()
            }
        }
    }
    
    private func fetchFavourites(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void ) {
        statisticsService.fetchFavourites { [weak self] result in
            switch result {
            case .success(let likes):
                self?.favoutiteNfts = likes.likes
                completionOnSuccess()
            case .failure(_):
                completionOnFailure()
            }
        }
    }
    
    private func fetchCart(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void ) {
        statisticsService.fetchCart { [weak self] result in
            switch result {
            case .success(let cartList):
                self?.nftInCart = cartList.nfts
                completionOnSuccess()
            case .failure(_):
                completionOnFailure()
            }
        }
    }
    
    private func updateCart(nft: CartOrder, completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void ){
        statisticsService.updateCart(ids: nft) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchCart(completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
            case .failure:
                completionOnFailure()
            }
        }
    }
    
    func getNftCount() -> Int {
        return nftList.count
    }
    
    func nftForIndex(index: Int) -> NftInfo? {
        if index > nftList.count - 1 { return nil }
        return nftList[index]
    }
}
