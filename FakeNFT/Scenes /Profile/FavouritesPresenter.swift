//
//  FavouritesPresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import UIKit

final class FavouritesPresenter {
    var nfts: [NFT] = []
    
    private weak var view: FavouritesViewProtocol?
    private let nftService = NFTService.shared
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }

    func loadFavouriteNFTs(_ nftIDs: [String]) {
        nftService.fetchNfts(idsfNft: nftIDs) { [weak self] resultNft in
            guard let self = self else { return }
            switch resultNft {
            case .success(_):
                nfts = self.nftService.arrayOfNfts
                view?.reloadData()
            case .failure(_):
                print("Failed to load NFTs")
            }
        }
    }

    func getNumberOfItems() -> Int {
        return nfts.count
    }

    func getNFT(at index: Int) -> NFT {
        return nfts[index]
    }
}
