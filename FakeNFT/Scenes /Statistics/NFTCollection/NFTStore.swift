//
//  NFTStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//
import Foundation

final class NFTStore {
    let statisticsService = StatisticNetworkServise()
    
    private let nftIndexes: [String]
    private var nftList: [NftInfo] = []
    
    
    init(nftIndexes: [String]) {
        self.nftIndexes = nftIndexes
    }
    
    func fetch(completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        fetchNfts(nftIndexes: nftIndexes, completionOnSuccess: completionOnSuccess, completionOnFailure: completionOnFailure)
    }
    
    private func fetchNfts(nftIndexes: [String], completionOnSuccess: @escaping () -> Void, completionOnFailure: @escaping () -> Void) {
        let group = DispatchGroup()
        for index in nftIndexes {
            group.enter()
            statisticsService.fetchNft(id: index) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nftList.append(nft)
                    group.leave()
                case .failure:
                    completionOnFailure()
                    group.leave()
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            completionOnSuccess()
        }
    }
    
    func getNftCount() -> Int {
        return nftList.count
    }
    
    func nftForIndex(index: Int) -> NftInfo? {
        if index > nftList.count - 1 { return nil }
        return nftList[index]
    }
}
