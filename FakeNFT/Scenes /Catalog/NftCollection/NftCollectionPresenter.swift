import UIKit
import Kingfisher

protocol NftCollectionPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollection() -> NftCollectionViewModel
    func getNftsForView() -> [NftViewModel]
    func getNftsCount() -> Int
    func didTapLikeButtonFromCell(at indexPath: IndexPath)
    func didTapCartButtonFromCell(at indexPath: IndexPath)
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Private Properties
    
    private weak var view: NftCollectionViewProtocol?
    private var collectionId: String
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = NftCollectionService(networkClient: networkClient, id: collectionId)
    
    private var collectionResult = NftCollectionResultModel(name: "", cover: "", nfts: [""], description: "", author: "") {
        didSet {
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
    
    private var nftsForView: [NftViewModel] = [] {
        didSet {
            nftsForView = nftsForView.sorted(by: { $0.name < $1.name } )
            view?.setLoadingViewVisible(false)
        }
    }
    
    private var currentProfileData = NftLikesResultModel(name: "", avatar: "", description: "", website: "", nfts: [], likes: [], id: "") {
        didSet {
            favoriteNft = currentProfileData.likes
        }
    }
    
    private var favoriteNft: [String] = []
    private var nftInCart: [String] = []
    
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
    
    func didTapLikeButtonFromCell(at indexPath: IndexPath) {
        let nftId = nftsForView[indexPath.row].id
        updateLikeAndFetchState(for: nftId) { [weak view] isLiked in
            view?.updateLikeButtonState(for: indexPath, isLiked:isLiked)
            view?.setLoadingViewVisible(false)
        }
    }
    
    func didTapCartButtonFromCell(at indexPath: IndexPath) {
        let nftId = nftsForView[indexPath.row].id
        print("LOG didTapCartButtonFromCell for nft id \(nftId)")
    }
    
    //MARK: - Private Methods
    
    private func fetchDataWithOperationQueue() {
        view?.setLoadingViewVisible(true)
        
        let operationQueue = OperationQueue()
        
        let fetchCollectionOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)
            self.fetchNftCollection {
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let fetchLikesOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)
            self.fetchLikes {
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let fetchNftsInCartOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)
            self.fetchNftInCart {
                semaphore.signal()
            }
            semaphore.wait()
        }
        
        let fetchNftsOperation = BlockOperation {
            self.fetchNfts()
        }
        
        [fetchCollectionOperation, fetchLikesOperation, fetchNftsInCartOperation].forEach {
            fetchNftsOperation.addDependency($0)
        }
        
        operationQueue.addOperations([fetchCollectionOperation, fetchLikesOperation, fetchNftsInCartOperation, fetchNftsOperation], waitUntilFinished: false)
    }
    
    private func fetchNftCollection(completion: @escaping () -> Void) {
        networkService.loadNftCollection { [weak self]  result  in
            switch result {
                case .success(let nftCollection):
                    self?.collectionResult = nftCollection
                    completion()
                case .failure(let error):
                    self?.view?.showNetworkError()
                    print("LOG ERROR: NftCollectionPresenter fetchNftCollection – \(String(describing: error))")
                    completion()
            }
        }
    }
    
    private func fetchLikes(completion: @escaping () -> Void) {
        let networkService = NftLikesService(networkClient: networkClient)
        
        networkService.loadNftLikes { [weak self] result in
            switch result {
                case .success(let profileData):
                    self?.currentProfileData = profileData
                    completion()
                case .failure(let error):
                    print("LOG ERROR: NftCollectionPresenter fetchLikes – \(String(describing: error))")
                    completion()
            }
        }
    }
    
    private func fetchNftInCart(completion: @escaping() -> Void) {
        let networkService = NftCartService(networkClient: networkClient)
        
        networkService.loadNftInCart { [weak self] result in
            switch result {
                case .success(let nfts):
                    self?.nftInCart = nfts.nfts
                    completion()
                case .failure(let error):
                    print("LOG ERROR: NftCollectionPresenter fetchNftInCart – \(String(describing: error))")
                    completion()
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
                        self.view?.showNetworkError()
                        print("LOG ERROR: NftCollectionPresenter fetchNfts – \(String(describing: error))")
                }
            }
        }
    }
    
    private func updateLikeAndFetchState(for nftId: String, completion: @escaping (Bool) -> Void) {
        view?.setLoadingViewVisible(true)
        var updatedLikedNfts = currentProfileData.likes
        var isLiked = false
        if updatedLikedNfts.contains(nftId) {
            updatedLikedNfts.removeAll(where: { $0 == nftId })
        } else {
            updatedLikedNfts.append(nftId)
        }
        
        let networkService = NftLikesService(networkClient: networkClient)
        
        networkService.updateLikes(nftsIds: updatedLikedNfts, currentProfileData: currentProfileData) { [weak self] result in
            switch result {
                case .success(let updatedResult):
                    isLiked = updatedResult.likes.contains(nftId)
                    self?.currentProfileData = updatedResult
                    completion(isLiked)
                case.failure(let error):
                    completion(isLiked)
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
                isLiked: favoriteNft.contains($0.id),
                raiting: $0.rating,
                price: $0.price,
                isInCart: nftInCart.contains($0.id)
            )
            nftsForView.append(nft)
        }
        
        return nftsForView
    }
    
}
