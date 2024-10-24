//
//  NFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import Foundation

final class NFTCollectionPresenter {
    private let nfts: [NFT] = [
        NFT(name: "Archie", imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", price: 514.13, rating: 4),
        NFT(name: "Emma", imageURLString: "https://via.placeholder.com/200", price: 123.1, rating: 5),
        NFT(name: "Stella", imageURLString: "https://images.unsplash.com/photo-1547721064-da6cfb341d50", price: 41.4, rating: 1),
        NFT(name: "Toast", imageURLString: "https://via.placeholder.com/200", price: 22.1, rating: 2),
        NFT(name: "Zeus", imageURLString: "https://via.placeholder.com/200", price: 951.5, rating: 3)
    ]
    
    func getNFTsNumber() -> Int {
        nfts.count
    }
    
    func getNFTForIndex(index: Int) -> NFT? {
        return nfts[index]
    }
    
}
