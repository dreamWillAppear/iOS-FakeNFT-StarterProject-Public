//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

final class MyNFTPresenter: MyNFTPresenterProtocol {
    weak var view: MyNFTViewProtocol?
    var nfts: [NFT] = []
    
    private let nftService = NFTService()
    
    init(view: MyNFTViewProtocol) {
        self.view = view
    }
    
//    func loadNFTs(_ nftIDs: [String]) {
//        nfts = [
//            NFT(imageName: "nft1", likeImageName: "notLiked", name: "Lilo", ratingImageName: "rating3", author: "от John Doe", price: "1,78 ETH"),
//        ]
//        print(nftIDs)
//        view?.reloadData()
//    }
    
    func loadNFTs(_ nftIDs: [String]) {
        nfts = [] // Clear any previous data
        let dispatchGroup = DispatchGroup()
        let delayBetweenRequests: Double = 2 // Задержка между запросами в секундах

        print(nftIDs)
        for (index, nftID) in nftIDs.enumerated() {
            dispatchGroup.enter()
            
            // Рассчитываем задержку для текущего запроса
            let delay = delayBetweenRequests
            
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.nftService.fetchNFT(withID: nftID) { result in
                    defer { dispatchGroup.leave() }
                    
                    switch result {
                    case .success(let nft):
                        self?.nfts.append(nft)
                    case .failure(let error):
                        print("Failed to fetch NFT \(nftID): \(error.localizedDescription)")
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.view?.reloadData()
        }
    }
}

