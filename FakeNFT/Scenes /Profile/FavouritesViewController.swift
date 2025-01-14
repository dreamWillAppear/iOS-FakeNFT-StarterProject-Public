//
//  FavouritesViewController.swift
//  FakeNFT
//
//  Created by Bakgeldi Alkhabay on 16.10.2024.
//

import UIKit

final class FavouritesViewController: UIViewController, FavouritesViewProtocol {
    
    var nftIDs: [String]?
    
    private var presenter: FavouritesPresenter?
    
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
    
    private var noNFTLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "У вас еще нет избранных NFT"
        label.textAlignment = .center
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        presenter = FavouritesPresenter(view: self)
        if let nftIDs = nftIDs {
            presenter?.loadFavouriteNFTs(nftIDs)
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteNFTCell.self, forCellWithReuseIdentifier: "FavouriteNFTCell")
        
        addSubViews()
        applyConstraints()
    }
    
    func didTapLikeButton(on cell: FavouriteNFTCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        if let nft = presenter?.getNFT(at: indexPath.row),
            let nftIDs = nftIDs {
            presenter?.removeNft(withId: nft.id, in: nftIDs)
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func addSubViews() {
        [nameLabel, backButton, collectionView, noNFTLabel].forEach {
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func reloadData() {
        if presenter?.nfts.isEmpty == true {
            collectionView.isHidden = true
            noNFTLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noNFTLabel.isHidden = true
        }
        collectionView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FavouriteNFTCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.nfts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteNFTCell", for: indexPath) as? FavouriteNFTCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        if let nft = presenter?.nfts[indexPath.row] {
            cell.configure(
                name: extractNFTName(from: nft.images.first ?? ""),
                rating: "\(nft.rating)",
                price: nft.price,
                image: nft.images.first ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 16 + 7
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 80)
    }
}

extension FavouritesViewController {
    private func extractNFTName(from urlString: String) -> String {
        let pattern = #"\/([^\/]+)\/\d+\.png$"#
        let regex = try? NSRegularExpression(
            pattern: pattern,
            options: []
        )
        let nsString = urlString as NSString
        let results = regex?.firstMatch(
            in: urlString,
            options: [],
            range: NSRange(
                location: 0,
                length: nsString.length
            )
        )
        
        if let range = results?.range(
            at: 1
        ) {
            return nsString.substring(
                with: range
            )
        }
        return ""
    }
}
