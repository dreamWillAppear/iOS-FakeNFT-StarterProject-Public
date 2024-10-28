import UIKit
import Kingfisher

protocol NftCollectionPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollection() -> NftCollectionViewModel
    func getNftsForView() -> [NftViewModel]
    func getNftsCount() -> Int
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Private Properties
    
    private weak var view: NftCollectionViewProtocol?
    private var collectionId: String
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = NftCollectionService(networkClient: networkClient, id: collectionId)
    
    private var collectionResult = NftCollectionResultModel(name: "", cover: "", nfts: [""], description: "", author: "") {
        didSet {
            fetchNfts()
            collectionForView = convertResultToViewModel(result: collectionResult)
        }
    }
    
    private lazy var collectionForView = convertResultToViewModel(result: collectionResult) {
        didSet {
            view?.displayLoadedData()
        }
    }
    
    private var nftsResult: [NftCollectionCellResultModel] = [] {
        didSet {
            nftsForView = convertResultToViewModel(result: nftsResult)
            view?.reloadData()
        }
    }
    
    private var nftsForView: [NftViewModel] = []
    
    // MARK: - Initializers
    
    init(view: NftCollectionViewProtocol?, collectionId: String) {
        self.view = view
        self.collectionId = collectionId
    }
    
    //MARK: - Public Methods
    
    func setView(_ view: NftCollectionViewProtocol) {
        self.view = view
    }
    
    func onViewDidLoad() {
        fetchDataWithOperationQueue()
    }
    
    func getCollection() -> NftCollectionViewModel {
        collectionForView
    }
    
    func getNftsForView() -> [NftViewModel] {
        nftsForView
    }
    
    func getNftsCount() -> Int {
        nftsForView.count
    }
    
    //MARK: - Private Methods
    
    private func fetchDataWithOperationQueue() {
        let operationQueue = OperationQueue()
        
        let fetchCollectionOperation = BlockOperation {
            self.fetchNftCollection()
        }
        
        let fetchNftsOperation = BlockOperation {
            self.fetchNfts()
        }
        
        fetchNftsOperation.addDependency(fetchCollectionOperation)
        
        operationQueue.addOperations([fetchCollectionOperation, fetchNftsOperation], waitUntilFinished: false)
    }
    
    private func fetchNftCollection() {
        networkService.loadNftCollection { result  in
            switch result {
                case .success(let nftCollection):
                    self.collectionResult = nftCollection
                case .failure(let error):
                    print("LOG ERROR: NftCollectionPresenter fetchNftCollection – \(String(describing: error))")
            }
        }
    }
    
    private func fetchNfts() {
        collectionResult.nfts.forEach { [weak self] in
            guard let self = self else { return }
            let networkService = NftCollectionCellService(networkClient: self.networkClient, id: $0)
            
            networkService.loadNftCollection { result in
                switch result {
                    case .success(let nft):
                        self.nftsResult.append(nft)
                    case .failure(let error):
                        print("LOG ERROR: NftCollectionPresenter fetchNfts – \(String(describing: error))")
                }
            }
        }
    }
    
    private func convertResultToViewModel(result: NftCollectionResultModel) -> NftCollectionViewModel {
        NftCollectionViewModel(
            name: collectionResult.name,
            cover: URL(string: result.cover) ?? URL(fileURLWithPath: ""),
            authorName: collectionResult.author,
            description: collectionResult.description,
            nfts: collectionResult.nfts
        )
    }
    
    private func convertResultToViewModel(result: [NftCollectionCellResultModel]) -> [NftViewModel] {
        var nftsForView: [NftViewModel] = []
        
        result.forEach {
            let nft = NftViewModel(
                id: $0.id,
                cover: URL(string: $0.images.first ?? "") ?? URL(fileURLWithPath: ""),
                name: $0.name,
                isLiked: true,
                raiting: $0.rating,
                price: $0.price,
                isInCart: true
            )
            nftsForView.append(nft)
        }
        
        return nftsForView
    }
    
}
