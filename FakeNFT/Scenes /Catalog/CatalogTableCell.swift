import UIKit

final class CatalogTableCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    static let reuseIdentifier = "CatalogTableCell"
    
    private lazy var nftCollectionCover: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 12
        cover.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 0.5)
        
        return cover
    }()
    
    private lazy var nftCollectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    // MARK: - Public Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(cover: UIImage, label: String){
        nftCollectionCover.image = cover
        nftCollectionLabel.text = label
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .ypLightGrey
        selectedBackground.layer.masksToBounds = true
        selectedBackground.layer.cornerRadius = nftCollectionCover.layer.cornerRadius
        selectedBackgroundView = selectedBackground
        
        let views = [nftCollectionCover, nftCollectionLabel]
        
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
            nftCollectionCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCollectionCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCollectionCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            
            nftCollectionLabel.topAnchor.constraint(equalTo: nftCollectionCover.bottomAnchor, constant: 4),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
