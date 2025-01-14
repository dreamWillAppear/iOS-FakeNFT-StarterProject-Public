//
//  FavouritesPresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import UIKit

final class FavouritesPresenter {
    var nfts: [NFT] = []
    
    private let changeLikeService = ChangeLikesService.shared
    private weak var view: FavouritesViewProtocol?
    private let nftService = NFTService.shared
    private var likes: [String] = []
    
    init(view: FavouritesViewProtocol) {
        self.view = view
    }

    func loadFavouriteNFTs(_ nftIDs: [String]) {
        nfts.removeAll()
        likes = nftIDs
        
        if !likes.isEmpty {
            nftService.fetchNfts(idsfNft: nftIDs) { [weak self] resultNft in
                guard let self = self else { return }
                switch resultNft {
                case .success(_):
                    nfts = self.nftService.arrayOfNfts
                    //nfts = [] - проверка заглушки
                    view?.reloadData()
                case .failure(_):
                    print("Failed to load NFTs")
                }
            }
        } else {
            nfts = []
            view?.reloadData()
        }
    }
    
    func removeNft(withId id: String, in nftIDs: [String]) {
        var likes = nftIDs
        if let index = likes.firstIndex(of: id) {
            likes.remove(at: index)
            changeLikeService.changeLikes(with: likes)
            self.view?.reloadData()
            
            if var viewController = view as? FavouritesViewController {
                viewController.nftIDs = likes
            }
        }
        
        if let index = nfts.firstIndex(where: { $0.id == id }) {
            nfts.remove(at: index)
            view?.reloadData()
        }
    }

    func getNumberOfItems() -> Int {
        return nfts.count
    }

    func getNFT(at index: Int) -> NFT {
        return nfts[index]
    }
}
