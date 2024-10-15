import UIKit

protocol CatalogPresenterProtocol {
    func onViewDidLoad()
    func getCollectionCount() -> Int
    func getCollectionCover(at index: Int) -> UIImage
    func getCollectionLabel(at index: Int) -> String
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var view: CatalogViewProtocol?
    private var nftCollections: [CatalogModel] = []
    
    // MARK: - Initializers
    
    init(view: CatalogViewProtocol?) {
        self.view = view
    }
    
    //MARK: - Public Methods
    
    func setView(_ view: CatalogViewProtocol) {
        self.view = view
    }
    
    func onViewDidLoad() {
        nftCollections.append(CatalogModel(nftCollectionCover: UIImage(named: "AppIcon")!, nftCollectionName: "Collection1 (25)"))
        nftCollections.append(CatalogModel(nftCollectionCover: UIImage(named: "AppIcon")!, nftCollectionName: "Collection2 (32)"))
        
        view?.reloadData()
    }
    
    func getCollectionCount() -> Int {
        nftCollections.count
    }
    
    func getCollectionCover(at index: Int) -> UIImage {
        nftCollections[index].nftCollectionCover
    }
    
    func getCollectionLabel(at index: Int) -> String {
        nftCollections[index].nftCollectionName
    }
}
