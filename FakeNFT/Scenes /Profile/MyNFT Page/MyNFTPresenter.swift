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
                //nfts = []
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
            return extractNFTName(from: value1.images.first ?? "") < extractNFTName(from: value2.images.first ?? "")
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
    
    private func extractNFTName(from urlString: String) -> String {
        let pattern = #"\/([^\/]+)\/\d+\.png$"#
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        )
        let nsString = urlString as NSString
        let results = regex?.firstMatch(
            in: urlString,
            options: [],
            range: NSRange(
                location: 0,
                length: nsString.length
            )
        )
        
        if let range = results?.range(
            at: 1
        ) {
            return nsString.substring(
                with: range
            )
        }
        return ""
    }
}

