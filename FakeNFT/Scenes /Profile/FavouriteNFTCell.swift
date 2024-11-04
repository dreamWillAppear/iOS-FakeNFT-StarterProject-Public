//
//  FavouriteNFTCell.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 16.10.2024.
//

import UIKit
import Kingfisher

protocol FavouriteNFTCellDelegate: AnyObject {
    func didTapLikeButton(on cell: FavouriteNFTCell)
}

final class FavouriteNFTCell: UICollectionViewCell {
    
    weak var delegate: FavouriteNFTCellDelegate?
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlack
        return button
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption1
        label.textColor = .ypBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, rating: String, price: Double, image: String) {
        nameLabel.text = name
        priceLabel.text = "\(price)"
        likeButton.setImage(UIImage(named: "liked"), for: .normal)
        
        nftImageView.kf.setImage(with: URL(string: image))
        
        switch rating {
        case "1":
            ratingImageView.image = UIImage(named: "star1")
        case "2":
            ratingImageView.image = UIImage(named: "star2")
        case "3":
            ratingImageView.image = UIImage(named: "star3")
        case "4":
            ratingImageView.image = UIImage(named: "star4")
        case "5":
            ratingImageView.image = UIImage(named: "star5")
        default:
            ratingImageView.image = UIImage(named: "star0")
        }
    }
    
    @objc private func likeButtonTapped() {
        print("cell tapped")
        delegate?.didTapLikeButton(on: self)
    }
    
    private func setupCell() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(infoView)
        contentView.addSubview(likeButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        infoView.addSubview(nameLabel)
        infoView.addSubview(ratingImageView)
        infoView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            infoView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 7),
            infoView.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -7),
            infoView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            ratingImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingImageView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor)
        ])
    }
}

