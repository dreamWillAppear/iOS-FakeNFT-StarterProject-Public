//
//  UserProfileViewController.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 13.10.2024.
//

import UIKit

final class UserProfileViewController: UIViewController {
    private let backButtonImageName = "backwardButton"
    private let placeholder = UIImage(systemName: "person.crop.circle.fill")
    private var presenter: UserProfilePresenterProtocol
    private let backButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.tintColor = .segmentActive
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.segmentActive?.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let nftNumberLabel = {
        let nftNumberLabel = UILabel()
        nftNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        nftNumberLabel.font = .systemFont(ofSize: 17, weight: .bold)
        return nftNumberLabel
    }()

    private let collectionLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Коллекция NFT "
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let arrowImageView = {
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = .black
        return arrowImageView
    }()
    
    private let nftCollectionView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    private let profileBlock: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(presenter: UserProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        addSubViews()
        setupConstraints()
        backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        nftCollectionView.addTarget(self, action: #selector(openCollectionButtonTapped), for: .touchUpInside)
        websiteButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func openCollectionButtonTapped() {
        guard let presenterForCollection = presenter.presenterForCollection() else { return }
        let vc = NFTCollectionViewController(presenter: presenterForCollection)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openWebsite() {
        guard let url = presenter.webSiteURL() else { return }
        let webVC = UserProfileWebView(url: url)
        let navController = UINavigationController(rootViewController: webVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    
    private func setupUI() {
        guard let profile = presenter.profile() else { return }
        updateInfo(
            nftNumber: profile.nfts.count,
            image: profile.avatar,
            name: profile.name,
            description: profile.description,
            profileURL: profile.website
        )
    }
    
    private func addSubViews() {
        view.addSubview(profileBlock)
        profileBlock.addSubview(profileImageView)
        profileBlock.addSubview(nameLabel)
        profileBlock.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(nftCollectionView)
        nftCollectionView.addSubview(nftNumberLabel)
        nftCollectionView.addSubview(collectionLabel)
        nftCollectionView.addSubview(arrowImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            profileBlock.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileBlock.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileBlock.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileBlock.bottomAnchor.constraint(equalTo: websiteButton.topAnchor, constant: -28),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: profileBlock.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileBlock.leadingAnchor, constant: 16),
            profileImageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -16),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: profileBlock.bottomAnchor),
   
            websiteButton.topAnchor.constraint(equalTo: profileBlock.bottomAnchor, constant: 28),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            websiteButton.bottomAnchor.constraint(equalTo: nftCollectionView.topAnchor, constant: -40),
            
            nftCollectionView.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.heightAnchor.constraint(equalToConstant: 54),
            
            collectionLabel.leadingAnchor.constraint(equalTo: nftCollectionView.leadingAnchor),
            collectionLabel.centerYAnchor.constraint(equalTo: nftCollectionView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: nftCollectionView.trailingAnchor, constant: -16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: nftCollectionView.centerYAnchor),
            
            nftNumberLabel.leadingAnchor.constraint(equalTo: collectionLabel.trailingAnchor),
            nftNumberLabel.centerYAnchor.constraint(equalTo: nftCollectionView.centerYAnchor),
        ])
    }
    
    private func updateInfo(nftNumber: Int, image: String, name: String, description: String, profileURL: String) {
        updateNFTNumber(nftNumber: nftNumber)
        updateProfileImage(image: image)
        updateName(name: name)
        updateDescription(description: description)
        updateProfileURL(profileURL: profileURL)
    }
    
    private func updateNFTNumber(nftNumber: Int) {
        nftNumberLabel.text = "(\(nftNumber))"
    }
    
    private func updateProfileImage(image: String) {
        guard let url = URL(string: image) else {
            profileImageView.image = placeholder
            profileImageView.tintColor = UIColor.segmentActive
            return
        }
        profileImageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    private func updateName(name: String) {
        nameLabel.text = name
    }
    
    private func updateDescription(description: String) {
        descriptionLabel.text = description
    }
    
    private func updateProfileURL(profileURL: String) {
    }
}
