import UIKit

protocol CatalogPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollectionCount() -> Int
    func getCollectionLabel(at index: Int) -> String
    func getCollectionCoverURL(at index: Int) -> URL
    func getCollectionId(at index: Int) -> String
    func sortByName()
    func sortByCount()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var view: CatalogViewProtocol?
    
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = CatalogService(networkClient: networkClient)
    
    private let userDefaultsManager = UserDefaultsManager()
    
    private var nftCollections: [CatalogViewModel] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    private var nftCollectionsResult: [CatalogResultModel] = [] {
        didSet {
            nftCollections = convertResultToViewModel(result: nftCollectionsResult)
            checkSelectedFilter()
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
        guard index <= nftCollections.count else {
            return ""
        }
        
        return "\(nftCollections[index].nftCollectionName) (\(nftCollections[index].nftsCount))"
    }
    
    func getCollectionCoverURL(at index: Int) -> URL {
        guard index <= nftCollections.count else {
            return URL(fileURLWithPath: "")
        }
        
        return nftCollections[index].nftCollectionCoverURL
    }
    
    func getCollectionId(at index: Int) -> String {
        guard index <= nftCollections.count else {
            return ""
        }
        
        return  nftCollections[index].nftCollectionId
    }
    
    func sortByName() {
        let sortedNfts: [CatalogViewModel] = nftCollections.sorted { $0.nftCollectionName < $1.nftCollectionName }
        nftCollections = sortedNfts
        userDefaultsManager.saveCatalogFilterByName()
    }
    
    func sortByCount() {
        let sortedNfts: [CatalogViewModel] = nftCollections.sorted { $0.nftsCount > $1.nftsCount }
        nftCollections = sortedNfts
        userDefaultsManager.saveCatalogFilterByCount()
    }
    
    //MARK: - Private Methods
    
    private func fetchNftCollections() {
        view?.setLoadingViewVisible(true)
        
        networkService.loadCollections { [weak self] result in
            switch result {
                case .success(let result):
                    self?.nftCollectionsResult = result
                case .failure(let error):
                    print("LOG ERROR: CatalogPresenter networkService.loadCollections – \(String(describing: error))")
                    self?.view?.showNetworkError()
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
                    nftsCount: $0.nftCount,
                    nftCollectionId: $0.id
                )
            )
        }
        
        return collections
    }
    
    private func checkSelectedFilter() {
        guard let selectedFilter = userDefaultsManager.checkCatalogFilter() else {
            return
        }
        
        switch selectedFilter {
            case SelectedFilterEnum.byNameValue.rawValue:
                sortByName()
            case SelectedFilterEnum.byCountValue.rawValue:
                sortByCount()
            default:
                return
        }
    }
    
}
