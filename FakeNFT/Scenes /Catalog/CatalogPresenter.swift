import UIKit

protocol CatalogPresenterProtocol {
    func onViewDidLoad()
    func getCollectionCount() -> Int
    func getCollectionLabel(at index: Int) -> String
    func getCollectionCoverURL(at index: Int) -> URL
    func sortByName()
    func sortByCount()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var view: CatalogViewProtocol?
    
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = CatalogService(networkClient: networkClient)
    
    private var nftCollections: [CatalogViewModel] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    private var nftCollectionsResult: [CatalogResultModel] = [] {
        didSet {
            nftCollections = convertResultToViewModel(result: nftCollectionsResult)
        }
    }
    
    // MARK: - Initializers
    
    init(view: CatalogViewProtocol?) {
        self.view = view
    }
    
    //MARK: - Public Methods
    
    func setView(_ view: CatalogViewProtocol) {
        self.view = view
    }
    
    func onViewDidLoad() {
        fetchNftCollections()
    }
    
    func getCollectionCount() -> Int {
        nftCollections.count
    }
    
    func getCollectionLabel(at index: Int) -> String {
        "\(nftCollections[index].nftCollectionName) (\(nftCollections[index].nftsCount))"
    }
    
    func getCollectionCoverURL(at index: Int) -> URL {
        nftCollections[index].nftCollectionCoverURL
    }
    
    func sortByName() {
        var sortedNfts: [CatalogViewModel] = nftCollections.sorted { $0.nftCollectionName < $1.nftCollectionName }
        nftCollections = sortedNfts
    }
    
    func sortByCount() {
        
    }
    
    //MARK: - Private Methods
    
    private func fetchNftCollections() {
        view?.setLoadingViewVisible(true)
        
        networkService.loadCollections { [weak self] result in
            switch result {
                case .success(let result):
                    self?.nftCollectionsResult = result
                    print("LOG CatalogPresenter networkService.loadCollections – Success!")
                case .failure(let error):
                    print("LOG ERROR: CatalogPresenter networkService.loadCollections – \(String(describing: error))")
            }
            self?.view?.setLoadingViewVisible(false)
        }
    }
    
    private func convertResultToViewModel(result: [CatalogResultModel]) -> [CatalogViewModel] {
        var collections: [CatalogViewModel] = []
        result.forEach {
            collections.append(
                CatalogViewModel(
                    nftCollectionCoverURL: URL(string: $0.cover) ?? URL(fileURLWithPath: ""),
                    nftCollectionName: $0.name,
                    nftsCount: $0.nftCount
                )
            )
        }
        
        return collections
    }
    
}
