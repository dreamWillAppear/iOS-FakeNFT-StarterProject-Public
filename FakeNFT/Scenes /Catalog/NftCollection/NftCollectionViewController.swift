import UIKit

protocol NftCollectionViewProtocol: AnyObject {
    func reloadData()
    func setCover(image: UIImage)
    func setName(_ name: String)
    func setAuthorName(_ name: String)
    func setDescription(_ text: String)
}
