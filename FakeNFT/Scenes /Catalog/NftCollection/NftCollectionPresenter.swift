import UIKit
import Kingfisher

protocol NftCollectionPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollection() -> NftCollectionViewModel
    func getNftsCount() -> Int
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Private Properties
    
    private weak var view: NftCollectionViewProtocol?
    private var collectionId: String
    private var nfts: [NftViewModel] = []
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = NftCollectionService(networkClient: networkClient, id: collectionId)
    private lazy var cellNetworkService = NftCollectionCellService(networkClient: networkClient)
        
    private var collectionResult = NftCollectionResultModel(name: "", cover: "", nfts: [""], description: "", author: "") {
        didSet {
          collectionView = convertResultToViewModel(result: collectionResult)
        }
    }
    
    private lazy var collectionView = convertResultToViewModel(result: collectionResult) {
        didSet {
            view?.displayLoadedData()
        }
    }
    
    private var allNfts: [NftCollectionCellResultModel] = []
    
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
        fetchNftCollection()
        fetchAllNfts()
    }
    
    func getCollection() -> NftCollectionViewModel {
      collectionView
    }

    func getNftsCount() -> Int {
        nfts.count
    }
    
    //MARK: - Private Methods
    
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
    
    private func fetchAllNfts() {
        cellNetworkService.loadNftCollection { result in
            switch result {
                case .success(let nfts):
                    self.allNfts = nfts
                    print(nfts)
                case .failure(let error):
                    print("LOG ERROR: NftCollectionPresenter fetchAllNfts() – \(String(describing: error))")
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
    
}
