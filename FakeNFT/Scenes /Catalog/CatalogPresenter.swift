import UIKit
import Kingfisher

protocol CatalogPresenterProtocol {
    func onViewDidLoad()
    func getCollectionCount() -> Int
    func getCollectionLabel(at index: Int) -> String
    func getCollectionCoverURL(at index: Int) -> URL
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var view: CatalogViewProtocol?
    
    private let networkClient = DefaultNetworkClient()
    private lazy var networkService = CatalogService(networkClient: networkClient)
    private var nftCollections: [CatalogViewModel] = []
    
    private var nftCollectionsResult: [CatalogResultModel] = [] {
        didSet {
            nftCollections = convertResultToViewModel(result: nftCollectionsResult)
            view?.reloadData()
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
        nftCollections[index].nftCollectionName
    }
    
    func getCollectionCoverURL(at index: Int) -> URL {
        nftCollections[index].nftCollectionCoverURL
    }
    
    
    //MARK: - Private Methods
    
    private func fetchNftCollections() {
        networkService.loadCollections { [weak self] result in
            switch result {
                case .success(let result):
                    self?.nftCollectionsResult = result
                    print("LOG CatalogPresenter networkService.loadCollections – Success!")
                case .failure(let error):
                    print("LOG ERROR: CatalogPresenter networkService.loadCollections – \(String(describing: error))")
            }
        }
    }
    
    private func convertResultToViewModel(result: [CatalogResultModel]) -> [CatalogViewModel] {
        var collections: [CatalogViewModel] = []
        result.forEach {
            collections.append(
                CatalogViewModel(
                    nftCollectionCoverURL: URL(string: $0.cover) ?? URL(fileURLWithPath: ""),
                    nftCollectionName: $0.name
                )
            )
        }
        
        return collections
    }
    
}
