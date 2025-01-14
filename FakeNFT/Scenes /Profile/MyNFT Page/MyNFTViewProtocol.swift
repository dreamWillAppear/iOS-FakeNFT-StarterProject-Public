//
//  MyNFTViewProtocol.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 17.10.2024.
//

import Foundation

protocol MyNFTViewProtocol: AnyObject {
    func reloadData()
    var arrayOfNfts: [NFT] { get set }
}
