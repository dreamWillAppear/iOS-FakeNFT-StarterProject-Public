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
    weak var view: NFTCollectionViewController?
    init(nfts: [String]) {
        self.nftsIds = nfts
        self.nftsStore = NFTStore(nftIndexes: nfts)
        nftsStore.presenter = self
    }
    
    func getNFTsNumber() -> Int {
        nftsStore.getNftCount()
    }
    
    func getNFTForIndex(index: Int) -> NftInfo? {
        return nftsStore.nftForIndex(index: index)
    }
    
    func reloadView() {
        view?.reloadCollectionView()
    }
    
}
