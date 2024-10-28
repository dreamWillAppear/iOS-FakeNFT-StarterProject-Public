import UIKit

final class NftCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "NftCollectionViewCell"
    
    // MARK: - Private Properties
    
    private lazy var coverImageView: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = 12
        return cover
    }()
    
    private lazy var likeButton: UIButton  = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.ypWhiteUniversal ?? .white, renderingMode: .alwaysOriginal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var raitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0.75
        stackView.distribution = .fillEqually
        
        let whiteStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypLightGrey ?? .lightGray, renderingMode: .alwaysOriginal)
        
        (0..<5).forEach { _ in
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = whiteStarImage
            stackView.addArrangedSubview(starImageView)
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
    
    func configureCell(cover: URL, name: String, isLiked: Bool, raitng: Int, price: Float, isInCart: Bool) {
        coverImageView.kf.setImage(with: cover)
        nameLabel.text = name
        priceLabel.text = String(price) + " ETH"
        
        updateLikeButtonState(isLiked: isLiked)
        updateRaitingStackView(raitng: raitng)
        updateCartButtonState(isInCart: isInCart)
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
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 192),
            
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            raitingStackView.widthAnchor.constraint(equalToConstant: 68),
            raitingStackView.heightAnchor.constraint(equalToConstant: 12),
            raitingStackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            raitingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 68),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.topAnchor.constraint(equalTo: raitingStackView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.widthAnchor.constraint(equalToConstant: 68),
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: raitingStackView.bottomAnchor, constant: 5),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func updateRaitingStackView(raitng: Int) {
        let yellowStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypYellowUniversal ?? .yellow).withRenderingMode(.alwaysOriginal)
        let whiteStarImage = UIImage(systemName: "star.fill")?.withTintColor(.ypLightGrey ?? .lightGray, renderingMode: .alwaysOriginal)
        
        guard raitng <= 5 else {
            return
        }
        
        //проходимся по вьюхам и меняем картинку на желтую звезду пока index меньше рейтинга, но не очень понятно - подойдет ли для RTL
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
        likeButton.setImage(likeButtonImage, for: .normal)
    }
    
    private func updateCartButtonState(isInCart: Bool) {
        let addToCartImage = UIImage(named: "AddToCart")?.withTintColor(.ypBlack ?? .black).withRenderingMode(.alwaysOriginal)
        let removeFromCartImage = UIImage(named: "RemoveFromCart")?.withTintColor(.ypBlack ?? .black).withRenderingMode(.alwaysOriginal)
        let cartButtonImage = isInCart ? removeFromCartImage : addToCartImage
        cartButton.setImage(cartButtonImage, for: .normal)
    }
    
}
