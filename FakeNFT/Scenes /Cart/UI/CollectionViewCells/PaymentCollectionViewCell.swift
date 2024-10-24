//
//  PaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Konstantin on 16.10.2024.
//

import UIKit

final class PaymentCollectionViewCell: UICollectionViewCell {
       
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var paymentImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var paymentName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    lazy var paymentShortName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGreenUniversal
        return label
    }()
    
    static let identifier = "PaymentCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [paymentImage,
         paymentName,
         paymentShortName].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            paymentImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            paymentImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            paymentImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            paymentImage.widthAnchor.constraint(equalTo: paymentImage.heightAnchor),
            
            paymentName.leadingAnchor.constraint(equalTo: paymentImage.trailingAnchor, constant: 4),
            paymentName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            
            paymentShortName.leadingAnchor.constraint(equalTo: paymentImage.trailingAnchor, constant: 4),
            paymentShortName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            
        ])
    }
}
