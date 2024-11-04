//
//  MyNFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    var nfts: [NFT] { get }
    func loadNFTs(_ nftIDs: [String])
    func sortByPrice()
    func sortByRating()
    func sortByName()
}
