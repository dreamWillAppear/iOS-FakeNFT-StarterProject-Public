//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import UIKit

final class MyNFTPresenter: MyNFTPresenterProtocol {
    weak var view: MyNFTViewProtocol?
    var nfts: [NFT] = []
    
    init(view: MyNFTViewProtocol) {
        self.view = view
    }
    
    func loadNFTs() {
        nfts = [
            NFT(imageName: "nft1", likeImageName: "notLiked", name: "Lilo", ratingImageName: "rating3", author: "от John Doe", price: "1,78 ETH"),
        ]
        view?.reloadData()
    }
}

