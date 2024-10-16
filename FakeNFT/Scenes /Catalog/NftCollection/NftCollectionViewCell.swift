import UIKit

final class NftCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "NftCollectionViewCell"
    
    // MARK: - Private Properties
    
    private lazy var cover: UIImageView = {
        let cover = UIImageView()
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = 12
        return cover
    }()
    
    private lazy var likeButton: UIButton  = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.ypWhiteUniversal ?? .white, renderingMode: .alwaysOriginal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return button
    }()
    
    private lazy var raitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.75
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private func setupUI() {
        
        let views = [cover, likeButton, raitingStackView, nameLabel, priceLabel, cartButton]
        
        views.forEach {
            contentView.addSubview($0)
        }
        
        setupLayout(for: views)
    }
    
    private func setupLayout(for views: [UIView]) {
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}

