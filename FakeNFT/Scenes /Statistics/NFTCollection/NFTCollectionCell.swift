//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import UIKit
import Kingfisher

protocol NFTCollectionCellDelegate: AnyObject {
    func cartButtonTapped(_ cell: NFTCollectionCell)
    func likeButtonTapped(_ cell: NFTCollectionCell)
}

final class NFTCollectionCell: UICollectionViewCell {
    weak var delegate: NFTCollectionCellDelegate?
    private let starRating: StarRatingView = {
        let rating = StarRatingView()
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.isUserInteractionEnabled = false
        return rating
    }()

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    
    private let cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(notInCartImage, for: .normal)
        return button
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        return label
    }()
    
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor.black
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(unlikedButtonImage, for: .normal)
        return button
    }()
    
    func setupCell(nftName: String, nftPrice: Double, imageURLString: String, rating: Int, delegate: NFTCollectionCellDelegate) {
        self.delegate = delegate
        nftNameLabel.text = nftName
        nftPriceLabel.text = "\(nftPrice) ETH"
        starRating.setStars(rating: rating)
        
        let imageURL = URL(string: imageURLString)
        nftImageView.kf.setImage(with: imageURL)
        
        addSubviews()
        applyConstraints()
        setupButtons()
    }
    
    func setFavourite(_ isFav: Bool) {
        likeButton.setImage(isFav ? Self.likedButtonImage : Self.unlikedButtonImage, for: .normal)
    }
    
    func setInCart(_ inCart: Bool) {
        cartButton.setImage(inCart ? Self.inCartImage : Self.notInCartImage, for: .normal)
    }
    
    
    private func addSubviews() {
        [nftImageView, nftNameLabel, nftPriceLabel, starRating, cartButton, likeButton].forEach { addSubview($0) }
    }
    
    private func setupButtons() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        delegate?.likeButtonTapped(self)
    }
    
    @objc private func cartButtonTapped() {
        delegate?.cartButtonTapped(self)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            starRating.leadingAnchor.constraint(equalTo: leadingAnchor),
            starRating.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            starRating.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
            starRating.heightAnchor.constraint(equalToConstant: 12),
            
            nftNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nftNameLabel.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 4),
            
            nftPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nftPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartButton.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 4),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension NFTCollectionCell {
    static let unlikedButtonImage = UIImage(named: "whiteHeart")
    static let likedButtonImage = UIImage(named: "redHeart")
    static let notInCartImage = UIImage(named: "notInCartButtonImage")
    static let inCartImage = UIImage(named: "nftInCart")
    static let reuseIdentifier = "NFTCollectionCell"
}
