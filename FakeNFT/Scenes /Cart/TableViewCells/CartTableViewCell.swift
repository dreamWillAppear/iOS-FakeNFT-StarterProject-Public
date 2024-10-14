//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

final class CartTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var imageNFT: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var nameNFT: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var gradeNFT: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var priceNFT: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "cartDelete") ?? UIImage(),
            target: self,
            action: nil)
        button.backgroundColor = .clear
        button.tintColor = .ypBlack
        return button
    }()
    
    
    static let reuseIdentifier = "CartCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [imageNFT,
         nameNFT,
         gradeNFT,
         price,
         priceNFT,
         deleteButton].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 108),
            
            imageNFT.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            imageNFT.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            imageNFT.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            imageNFT.widthAnchor.constraint(equalTo: imageNFT.heightAnchor),
            
            nameNFT.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameNFT.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
            
            gradeNFT.topAnchor.constraint(equalTo: nameNFT.bottomAnchor, constant: 4),
            gradeNFT.leadingAnchor.constraint(equalTo: nameNFT.leadingAnchor),
            gradeNFT.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.11),
            gradeNFT.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.18),
            
            price.topAnchor.constraint(equalTo: gradeNFT.bottomAnchor, constant: 12),
            price.leadingAnchor.constraint(equalTo: nameNFT.leadingAnchor),
            
            priceNFT.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 2),
            priceNFT.leadingAnchor.constraint(equalTo: nameNFT.leadingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 34),
            deleteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34),
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
