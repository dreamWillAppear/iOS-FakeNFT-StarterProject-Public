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
    private var nftCollections: [CatalogViewModel] = []
    
    // MARK: - Initializers
    
    init(view: CatalogViewProtocol?) {
        self.view = view
    }
    
    //MARK: - Public Methods
    
    func setView(_ view: CatalogViewProtocol) {
        self.view = view
    }
    
    func onViewDidLoad() {
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverPeach")!, nftCollectionName: "Peach (11)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverBlue")!, nftCollectionName: "Blue (6)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverBrown")!, nftCollectionName: "Brown (8)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverGreen")!, nftCollectionName: "Green (7)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverGray")!, nftCollectionName: "Gray (5)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverYellow")!, nftCollectionName: "Yellow (999)"))
        nftCollections.append(CatalogViewModel(nftCollectionCover: UIImage(named: "MokeCoverWhite")!, nftCollectionName: "White (99)"))
        
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
