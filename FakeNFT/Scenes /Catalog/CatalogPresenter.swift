import UIKit

protocol CatalogPresenterProtocol {
    func onViewDidLoad()
    func getCollectionCount() -> Int
    func getCollection(at index: Int) -> CatalogModel
}

final class CatalogPresenter: CatalogPresenterProtocol {
    func onViewDidLoad() {
        
    }
    
    func getCollectionCount() -> Int {
        0
    }
    
    func getCollection(at index: Int) -> CatalogModel {
        CatalogModel(nftCollectionCover: UIImage(), nftCollectionName: "")
    }
}
