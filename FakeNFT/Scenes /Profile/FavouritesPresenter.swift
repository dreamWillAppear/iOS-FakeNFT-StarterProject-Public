//
//  FavouritesPresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import UIKit

final class FavouritesPresenter {
    private weak var view: FavouritesViewProtocol?
    private var favouriteNFTs: [FavouriteNFT] = []

    init(view: FavouritesViewProtocol) {
        self.view = view
    }

    func loadFavouriteNFTs() {
        favouriteNFTs = [
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
            FavouriteNFT(name: "Archie", rating: UIImage(named: "rating3"), price: "1,78 ETH", image: UIImage(named: "nft2"), liked: UIImage(named: "liked")),
        ]
        view?.reloadData()
    }

    func getNumberOfItems() -> Int {
        return favouriteNFTs.count
    }

    func getNFT(at index: Int) -> FavouriteNFT {
        return favouriteNFTs[index]
    }
}
