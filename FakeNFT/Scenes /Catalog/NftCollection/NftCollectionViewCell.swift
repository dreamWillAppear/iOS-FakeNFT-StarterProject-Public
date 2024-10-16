import UIKit

final class NftCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "NftCollectionViewCell"
    
    // MARK: - Private Properties
    
    private lazy var coverImageView: UIImageView = {
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
        
        let whiteStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypLightGrey ?? .lightGray, renderingMode: .alwaysOriginal)
        let starImageView = UIImageView()
        starImageView.image = whiteStarImage
        let starsArrayImageView = Array(repeating: starImageView, count: 5)
        
        starsArrayImageView.forEach {
            stackView.addArrangedSubview($0)
        }
        
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
    
    //MARK: - Public Methods
    
    private func configureCell(cover: UIImage, name: String, isLiked: Bool, raitng: Int, price: Float, isInCart: Bool) {

        
    }
    
    // MARK: - Private Properties
    
    private func setupUI() {
        
        contentView.backgroundColor = .ypWhite
        
        let views = [coverImageView, likeButton, raitingStackView, nameLabel, priceLabel, cartButton]
        
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
    
    private func updateRaitingStackView(raitng: Int) {
        let yellowStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypYellowUniversal ?? .yellow).withRenderingMode(.alwaysOriginal)
        let whiteStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypLightGrey ?? .lightGray, renderingMode: .alwaysOriginal)
        
        guard raitng <= 5 else {
            return
        }
        
        //проходимся по вьюхам и меняем картинку на желтую звезду пока index меньше рейтинга, но не очень понятно подойдет ли для RTL
        raitingStackView.arrangedSubviews.enumerated().forEach { index, view in
            (view as? UIImageView)?.image = index < raitng ? 
            yellowStarImage :
            whiteStarImage
        }
    }
    
    private func updateLikeButtonState(isLiked: Bool) {
        let whiteHeartImage = UIImage(systemName: "heart.fill")?.withTintColor(.ypWhiteUniversal ?? .white).withRenderingMode(.alwaysOriginal)
        let redHeartImage = UIImage(systemName: "heart.fill")?.withTintColor(.ypRedUniversal ?? .red).withRenderingMode(.alwaysOriginal)
        let likeButtonImage = isLiked ? redHeartImage : whiteHeartImage
    }
    
    private func updateCartButtonState(isInCart: Bool) {
        let addToCartImage = UIImage(named: "AddToCart")
        let removeFromCartImage = UIImage(named: "removeFromCart")
        let cartButtonImage = isInCart ? removeFromCartImage : addToCartImage
        cartButton.setImage(cartButtonImage, for: .normal)
    }
    
    
}

