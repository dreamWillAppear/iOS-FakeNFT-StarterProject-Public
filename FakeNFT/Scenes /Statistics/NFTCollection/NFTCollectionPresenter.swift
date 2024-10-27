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
        },
                        completionOnFailure: { [weak self] in
            self?.hideProgressHud()
        })
    }
}
