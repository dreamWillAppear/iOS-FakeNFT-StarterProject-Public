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
    
    private let nftService = NFTService.shared
    
    init(view: MyNFTViewProtocol) {
        self.view = view
    }
    
    func loadNFTs(_ nftIDs: [String]) {
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
    
    func getNfts() -> [NFT] {
        return nftService.arrayOfNfts
    }
    
    func sortByName() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.name < value2.name
        }
        self.nfts = sortedNfts
    }
    
    func sortByRating() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.rating > value2.rating
        }
        self.nfts = sortedNfts
    }
    
    func sortByPrice() {
        let nfts = getNfts()
        let sortedNfts = nfts.sorted{ (value1, value2) in
            return value1.price > value2.price
        }
        self.nfts = sortedNfts
    }
    
//    func loadNFTs(_ nftIDs: [String]) {
//        nfts = [] // Clear any previous data
//        let dispatchGroup = DispatchGroup()
//        let delayBetweenRequests: Double = 2 // Задержка между запросами в секундах
//
//        print(nftIDs)
//        for (index, nftID) in nftIDs.enumerated() {
//            dispatchGroup.enter()
//            
//            // Рассчитываем задержку для текущего запроса
//            let delay = delayBetweenRequests
//            
//            DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
//                self?.nftService.fetchNFT(withID: nftID) { result in
//                    defer { dispatchGroup.leave() }
//                    
//                    switch result {
//                    case .success(let nft):
//                        self?.nfts.append(nft)
//                    case .failure(let error):
//                        print("Failed to fetch NFT \(nftID): \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//        
//        dispatchGroup.notify(queue: .main) {
//            self.view?.reloadData()
//        }
//    }
}

