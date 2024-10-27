//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import Foundation

final class NFTCollectionPresenter: NFTStoreDelegateProtocol {
    private let nftsIds: [String]
    private let nftsStore: NFTStore
    weak var view: NFTCollectionViewControllerProtocol?
    init(nfts: [String]) {
        self.nftsIds = nfts
        self.nftsStore = NFTStore(nftIndexes: nfts)
        nftsStore.presenter = self
        nftsStore.fetch()
    }
    
    func showProgressHud() {
        view?.showProgressHud()
    }
    
    func hideProgressHud() {
        view?.hideProgressHud()
    }
    
    func getNFTsNumber() -> Int {
        nftsStore.getNftCount()
    }
    
    func getNFTForIndex(index: Int) -> NftInfo? {
        nftsStore.nftForIndex(index: index)
    }
    
    func reloadView() {
        view?.reloadCollectionView()
    }
    
}
