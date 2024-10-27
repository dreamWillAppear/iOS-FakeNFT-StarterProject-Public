//
//  NFTStore.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

protocol NFTStoreDelegateProtocol: AnyObject {
    func reloadView()
    func showProgressHud()
    func hideProgressHud()
}

final class NFTStore {
    let statisticsService = StatisticNetworkServise()
    weak var presenter: NFTStoreDelegateProtocol?
    
    private let nftIndexes: [String]
    private var nftList: [NftInfo] = []
    
    
    init(nftIndexes: [String]) {
        self.nftIndexes = nftIndexes
    }
    
    func fetch() {
        fetchNfts(nftIndexes: nftIndexes)
    }
    
    private func fetchNfts(nftIndexes: [String]) {
        presenter?.showProgressHud()
        for index in nftIndexes {
            statisticsService.fetchNft(id: index) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.presenter?.hideProgressHud()
                    self?.nftList.append(nft)
                    self?.presenter?.reloadView()
                case .failure:
                    self?.presenter?.hideProgressHud()
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
