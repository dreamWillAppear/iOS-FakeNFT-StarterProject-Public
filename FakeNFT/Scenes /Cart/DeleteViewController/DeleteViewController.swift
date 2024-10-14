//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Konstantin on 14.10.2024.
//

import UIKit

final class DeleteViewController: UIViewController {
    
    var dataNft: NftCart?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        let image: UIImage = dataNft?.image ?? UIImage()
        imageView.image = image
        return imageView
    }()
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Вы уверены, что хотите \n удалить объект из корзины?"
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var deleteButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.ypRedUniversal, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapDeleteButton), for: .touchDown)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var cancelButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapCancelButton), for: .touchDown)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
    }
    
    private func setupViews() {
        [nftImageView,
         deleteLabel,
         deleteButton,
         cancelButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 134),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -134),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            deleteLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            deleteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: deleteLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            deleteButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            cancelButton.topAnchor.constraint(equalTo: deleteButton.topAnchor),
            cancelButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            cancelButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor)
        ])
    }
    
    private func setupBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    @objc
    private func didTapDeleteButton() {
        //TODO: delete object from server
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
}
