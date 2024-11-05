//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 16.10.2024.
//

import UIKit
import Kingfisher

final class NFTTableViewCell: UITableViewCell {
    
    var nftImageView: UIImageView = {
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
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rating3")
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textColor = .ypBlack
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textColor = .ypBlack
        label.text = "Цена"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private let labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nftImageView)
        nftImageView.addSubview(likeButton)
        
        contentView.addSubview(labelsContainerView)
        
        labelsContainerView.addSubview(descriptionContainerView)
        labelsContainerView.addSubview(priceContainerView)
        
        [nameLabel, starImageView, authorLabel].forEach {
            descriptionContainerView.addSubview($0)
        }
        
        [priceTitleLabel, priceLabel].forEach {
            priceContainerView.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            
            labelsContainerView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 23),
            labelsContainerView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            labelsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            labelsContainerView.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -23),
            
            descriptionContainerView.topAnchor.constraint(equalTo: labelsContainerView.topAnchor),
            descriptionContainerView.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            descriptionContainerView.bottomAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            descriptionContainerView.widthAnchor.constraint(equalToConstant: 89),
            
            priceContainerView.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 10),
            priceContainerView.leadingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: 39),
            priceContainerView.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            priceContainerView.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor),
            
            starImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            starImageView.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 68),
            starImageView.heightAnchor.constraint(equalToConstant: 12),
            
            authorLabel.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 4),
            authorLabel.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            
            priceTitleLabel.topAnchor.constraint(equalTo: priceContainerView.topAnchor),
            priceTitleLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor),
            priceTitleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: priceContainerView.leadingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    func configure(image: UIImage?, likeImage: UIImage?, name: String, starImage: String, author: String, price: String) {
        nftImageView.image = image
        likeButton.setImage(likeImage, for: .normal)
        nameLabel.text = name
        //starImageView.image = starImage
        authorLabel.text = author
        priceLabel.text = price
        
        switch starImage {
        case "1":
            starImageView.image = UIImage(named: "star1")
        case "2":
            starImageView.image = UIImage(named: "star2")
        case "3":
            starImageView.image = UIImage(named: "star3")
        case "4":
            starImageView.image = UIImage(named: "star4")
        case "5":
            starImageView.image = UIImage(named: "star5")
        default:
            starImageView.image = UIImage(named: "star0")
        }
    }
}
