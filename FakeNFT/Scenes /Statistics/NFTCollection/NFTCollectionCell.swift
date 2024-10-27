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
        nftImageView.kf.setImage(with: imageURL)
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        [nftImageView, nftNameLabel, nftPriceLabel, starRating, cartImageView].forEach { addSubview($0) }
        nftImageView.addSubview(likeButton)
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
            
            cartImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartImageView.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 4),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            cartImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension NFTCollectionCell {
    static let likeButtonImage = UIImage(named: "likeButtonImage")
    static let reuseIdentifier = "NFTCollectionCell"
}
