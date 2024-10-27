//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import UIKit
import ProgressHUD

protocol NFTCollectionViewControllerProtocol: AnyObject {
    func reloadCollectionView()
    func showProgressHud()
    func hideProgressHud()
}

final class NFTCollectionViewController: UIViewController, NFTCollectionViewControllerProtocol {
    let presenter: NFTCollectionPresenter
    
    private let backButtonImageName = "backwardButton"
    private let navTitleText = "Коллекция NFT"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: NFTCollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        presenter.fetch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        applyConstraints()
        setupBackButton()
        navigationView()
        setupCollectionView()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func showProgressHud() {
        ProgressHUD.show()
    }
    
    func hideProgressHud() {
        ProgressHUD.dismiss()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func navigationView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = navTitleText
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NFTCollectionCell.self, forCellWithReuseIdentifier: NFTCollectionCell.reuseIdentifier)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}

extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nft = presenter.getNFTForIndex(index: indexPath.row),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionCell.reuseIdentifier, for: indexPath) as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(nftName: nft.name, nftPrice: nft.price, imageURLString: nft.images[0], rating: nft.rating, delegate: self)
        
        cell.setFavourite(presenter.isFavourite(index: indexPath.row))
        cell.setInCart(presenter.isInCart(index: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNFTsNumber()
    }
}

extension NFTCollectionViewController: UICollectionViewDelegate {
}

extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing: CGFloat) -> CGFloat {
        Layout.collectionViewMinimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Layout.collectionViewMinimumInteritemSpacing
    }
}

extension NFTCollectionViewController {
    enum Layout {
        static let cellHorizontalInset: CGFloat = 19
        static let cellVerticalInset: CGFloat = 32
        static let cellsCountInLine: CGFloat = 3
        static let cellsCountInColumn: CGFloat = 4
        static let collectionViewMinimumLineSpacing: CGFloat = 10
        static let collectionViewMinimumInteritemSpacing: CGFloat = 8
    }
}

extension NFTCollectionViewController: NFTCollectionCellDelegate {
    func cartButtonTapped(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        presenter.updateCartBy(index: indexPath.row)
    }
    
    func likeButtonTapped(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        presenter.updateFavouritesBy(index: indexPath.row)
    }
}
