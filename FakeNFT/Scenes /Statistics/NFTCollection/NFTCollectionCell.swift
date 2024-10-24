//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell {
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
    
    
    private let cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cartButtonImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        button.setImage(NFTCollectionCell.likeButtonImage, for: .normal)
        return button
    }()
    
    func setupCell(nftName: String, nftPrice: Double, imageURLString: String, rating: Int) {
        nftNameLabel.text = nftName
        nftPriceLabel.text = "\(nftPrice) ETH"
        starRating.setStars(rating: rating)
        
        let imageURL = URL(string: imageURLString)
//        nftImageView.kf.setImage(with: imageURL)
        nftImageView.image = UIImage(named: "card1")
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        [nftImageView, nftNameLabel, nftPriceLabel, starRating, cartImageView].forEach { addSubview($0) }
        nftImageView.addSubview(likeButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
//            nftImageView.widthAnchor.constraint(equalToConstant: 108),
//            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: starRating.topAnchor, constant: -8),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            starRating.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            starRating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starRating.trailingAnchor.constraint(equalTo: cartImageView.leadingAnchor),
            starRating.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -5),
            
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: cartImageView.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(equalTo: nftPriceLabel.topAnchor, constant: -4),
            nftNameLabel.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 5),
            
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftPriceLabel.trailingAnchor.constraint(equalTo: cartImageView.leadingAnchor),
            nftPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21),
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartImageView.leadingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),
            cartImageView.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 5),
            cartImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cartImageView.heightAnchor.constraint(equalToConstant: 40),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
    }
}

extension NFTCollectionCell {
    static let likeButtonImage = UIImage(named: "likeButtonImage")
    static let reuseIdentifier = "NFTCollectionCell"
}
