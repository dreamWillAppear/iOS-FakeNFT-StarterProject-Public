import UIKit

protocol NftCollectionPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollection() -> NftCollectionViewModel
    func  getNftsCount() -> Int
}

final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Private Properties
    
    private weak var view: NftCollectionViewProtocol?
    private var nfts: [NftViewModel] = []
    
    // MARK: - Initializers
    
    init(view: NftCollectionViewProtocol?) {
        self.view = view
    }
    
    //MARK: - Public Methods
    
    func setView(_ view: NftCollectionViewProtocol) {
        self.view = view
    }
    
    func onViewDidLoad() {
        setupMokeData()
    }
    
    func getCollection() -> NftCollectionViewModel {
        NftCollectionViewModel(
            name: "Peach",
            cover:  UIImage(named: "MokeCoverPeach")!,
            authorName: "John Doe",
            description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            nfts: [""]
        )
    }
    
    func getNftsCount() -> Int {
        nfts.count
    }
    
    //MARK: - Private Methods
    
    //временный метод с мок-данными для отладки UI
    private func setupMokeData() {
        let coverNames = ["MokeCellTater", "MokeCellSusan", "MokeCellRuby", "MokeCellPixi", "MokeCellNacho", "MokeCellDaisy", "MokeCellBiscuit", "MokeCellArchie"]
        var nfts = [NftViewModel]()
        
        for (index, coverName) in coverNames.enumerated() {
            let randomRating = Int.random(in: 0...5)
            let randomPrice = Float.random(in: 5...100)
            let isLiked = Bool.random()
            let isInCart = Bool.random()
            
            nfts.append(NftViewModel(
                id: "\(String(index + 1))",
                cover: UIImage(named: coverName)!,
                name: "AnyCollection\(index + 1)",
                isLiked: isLiked,
                raiting: randomRating,
                price: randomPrice,
                isInCart: isInCart
            ))
        }
    }
}
