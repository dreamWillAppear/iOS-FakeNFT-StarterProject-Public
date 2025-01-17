//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit
import ProgressHUD

protocol CartTableViewCellDelegate: AnyObject {
    func cartCellDidTapDelete(_ cell: CartTableViewCell)
}

final class CartTableViewCell: UITableViewCell {
    
    weak var delegate: CartTableViewCellDelegate?
    var modelNft: NftResult?
    var idNft: String?
    
    lazy var imageNFT: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var nameNFT: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var gradeNFT: UIImageView = {
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
    
    private lazy var priceNFT: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "cartDelete") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapDeleteButton))
        button.backgroundColor = .clear
        button.tintColor = .ypBlack
        return button
    }()
    
    
    static let reuseIdentifier = "CartCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupCell(nft: NftResult) {
        self.nameNFT.text = nft.name
        self.priceNFT.text = "\(nft.price) ETH".replacingOccurrences(of: ".", with: ",")
        self.gradeNFT.image = makeGradeImage(grade: nft.rating)
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
    
    private func makeGradeImage(grade: Int) -> UIImage? {
        let image = "grade\(grade)"
        return UIImage(named: image)
    }
    
    @objc
    private func didTapDeleteButton() {
        delegate?.cartCellDidTapDelete(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
