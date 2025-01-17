//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import Foundation

final class NFTCollectionPresenter {
    private let nftsIds: [String]
    private let nftsStore: NFTStore
    weak var view: NFTCollectionViewControllerProtocol?
    init(nfts: [String]) {
        self.nftsIds = nfts
        self.nftsStore = NFTStore(nftIndexes: nfts)
    }
    
    func getNFTsNumber() -> Int {
        nftsStore.getNftCount()
    }
    
    func getNFTForIndex(index: Int) -> NftInfo? {
        nftsStore.nftForIndex(index: index)
    }
    
    func fetch() {
        fetchData()
        fetchCart()
        fetchFavourites()
    }
    
    func updateFavouritesBy(index: Int, toAdd: Bool) {
        guard let id = getNFTForIndex(index: index)?.id else { return }
        updateFavourites(nft: id, toAdd: toAdd)
    }
    
    func updateCartBy(index: Int, toAdd: Bool) {
        guard let id = getNFTForIndex(index: index)?.id else { return }
        updateCart(nft: id, toAdd: toAdd)
    }
    
    func isInCart(index: Int) -> Bool {
        guard let nft = getNFTForIndex(index: index) else { return false }
        let id = nft.id
        return nftsStore.getCartList().contains(id)
    }
    
    func isFavourite(index: Int) -> Bool {
        guard let nft = getNFTForIndex(index: index) else { return false }
        let id = nft.id
        return nftsStore.getFavouriteList().contains(id)
    }
    
    private func showProgressHud() {
        view?.showProgressHud()
    }
    
    private func hideProgressHud() {
        view?.hideProgressHud()
    }
    
    private func reloadView() {
        view?.reloadCollectionView()
    }

    private func fetchData() {
        showProgressHud()
        nftsStore.fetch(completionOnSuccess: { [weak self] in
            self?.hideProgressHud()
            self?.reloadView()
        }, completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
    
    private func fetchCart() {
        showProgressHud()
        nftsStore.reloadCart(completionOnSuccess: { [weak self] in
            self?.hideProgressHud()
            self?.reloadView()
        }, completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
    
    private func fetchFavourites() {
        showProgressHud()
        nftsStore.reloadFavourites(completionOnSuccess: { [weak self] in
            self?.hideProgressHud()
            self?.reloadView()
        }, completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
    
    private func updateFavourites(nft: String, toAdd: Bool) {
        var ids = nftsStore.getFavouriteList()
        if toAdd {
            ids.append(nft)
        } else {
            ids.removeAll(where: { $0 == nft } )
        }
        
        let favourites = FavoutiteNft(likes: ids)
        showProgressHud()
        nftsStore.updateFavouriteByNft(nfts: favourites, completionOnSuccess: { [weak self] in
            self?.hideProgressHud()
            self?.reloadView()
        }, completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
    
    private func updateCart(nft: String, toAdd: Bool) {
        var ids = nftsStore.getCartList()
        if toAdd {
            ids.append(nft)
        } else {
            ids.removeAll(where: { $0 == nft } )
        }
        let cart = CartOrder(nfts: ids)
        showProgressHud()
        nftsStore.updateCartByNft(nfts: cart, completionOnSuccess: { [weak self] in
            self?.hideProgressHud()
            self?.reloadView()
        }, completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
}
