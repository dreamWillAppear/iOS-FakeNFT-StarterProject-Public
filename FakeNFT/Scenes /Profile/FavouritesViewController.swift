//
//  FavouritesViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 16.10.2024.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .ypBlack
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Избранные NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        label.textColor = .ypBlack
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteNFTCell.self, forCellWithReuseIdentifier: "FavouriteNFTCell")
        
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        [nameLabel, backButton, collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteNFTCell", for: indexPath) as! FavouriteNFTCell
        cell.configure(name: "Archie", ratingImage: UIImage(named: "rating3"), price: "1,78 ETH", nftImage: UIImage(named: "nft2"), likeImage: UIImage(named: "liked"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 16 + 7
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 80)
    }
}
