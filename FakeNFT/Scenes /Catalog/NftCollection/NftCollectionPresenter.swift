import UIKit

protocol NftCollectionPresenterProtocol: AnyObject {
    func onViewDidLoad()
    func getCollectionCover() -> UIImage
    func getCollectionName() -> String
    func getAuthorName() -> String
    func getDescription() -> String
    func getNftName() -> String
    func getNftRaiting() -> Int
    func getNftPrice() -> String
    func isInCart() -> Bool
    func isLiked() -> Bool
}

