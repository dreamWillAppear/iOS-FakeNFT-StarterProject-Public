//
//  NFTStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

final class NFTStore {
    let statisticsService = StatisticNetworkServise()
    private var nftList: [NftInfo] = []
    weak var presenter: NFTCollectionPresenter?
    init(nftIndexes: [String]) {
        fetchNfts(nftIndexes: nftIndexes)
    }
    
    func fetchNfts(nftIndexes: [String]) {
        for index in nftIndexes {
            statisticsService.fetchNft(id: index) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nftList.append(nft)
                    self?.presenter?.reloadView()
                case .failure:
                    break
                }
            }
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
